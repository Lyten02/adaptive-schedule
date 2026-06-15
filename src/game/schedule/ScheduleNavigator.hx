package game.schedule;

class ScheduleNavigator {
	static inline var DAY_MS:Float = 86400000;

	var today:Date;
	var offsetDays:Int = 0;

	public function new(?today:Date) {
		this.today = today == null ? Date.now() : today;
	}

	public function resetToday():Void offsetDays = 0;
	public function shiftDays(delta:Int):Void offsetDays += delta;
	public function shiftWeeks(delta:Int):Void offsetDays += delta * 7;

	public function selectedDate():Date {
		return Date.fromTime(noonMs(today) + offsetDays * DAY_MS);
	}

	public function selectedDay():Int return WeekCalendar.dayIndex(selectedDate());
	public function parity():WeekParity return WeekCalendar.parity(selectedDate());
	public function dayTitle():String return WeekCalendar.dayTitle(selectedDay());
	public function isToday():Bool return offsetDays == 0;

	public function weekLabel():String {
		var date = selectedDate();
		var n = WeekCalendar.weekNumber(date);
		var shift = Math.floor(offsetDays / 7);
		var suffix = shift == 0 ? "текущая" : (shift > 0 ? "+" + shift : Std.string(shift));
		return 'Неделя $n ($suffix), ${parity().label()}';
	}

	static function noonMs(date:Date):Float {
		return new Date(date.getFullYear(), date.getMonth(), date.getDate(), 12, 0, 0).getTime();
	}
}
