package game.schedule;

class ReminderService {
	var repo:ScheduleRepository;
	var lastKey:String = "";

	public function new(repo:ScheduleRepository) {
		this.repo = repo;
	}

	public function tick(groupId:String, enabled:Bool, minutesBefore:Int):Void {
		if (!enabled) return;
		var now = Date.now();
		var day = WeekCalendar.dayIndex(now);
		var parity = WeekCalendar.parity(now);
		for (l in repo.dayLessons(groupId, day, parity, "")) {
			var left = LessonTime.minutesUntil(now, l.start);
			if (left >= 0 && left <= minutesBefore) {
				var key = dateKey(now) + ":" + l.id;
				if (key != lastKey && ScheduleStorage.getString("lastReminder", "") != key) {
					lastKey = key;
					ScheduleStorage.setString("lastReminder", key);
					BrowserActions.notify("Скоро пара", l.title + " через " + left + " мин, " + l.room);
				}
				return;
			}
		}
	}

	static function dateKey(d:Date):String {
		return d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();
	}
}
