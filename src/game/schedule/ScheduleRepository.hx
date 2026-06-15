package game.schedule;

class ScheduleRepository {
	public var groups(default, null):Array<GroupInfo> = [];
	var byGroup:Map<String, Array<Lesson>> = new Map();

	public static function parse(json:String):ScheduleRepository {
		var data:ScheduleConfig = haxe.Json.parse(json);
		var repo = new ScheduleRepository();
		for (g in data.groups) repo.addGroup(g);
		return repo;
	}

	public function new() {}

	public function firstGroup():String {
		return groups.length > 0 ? groups[0].id : "";
	}

	public function groupTitle(id:String):String {
		var g = group(id);
		return g == null ? id : g.title;
	}

	public function group(id:String):Null<GroupInfo> {
		for (g in groups) if (g.id == id) return g;
		return null;
	}

	public function safeGroup(id:String):String {
		return group(id) != null ? id : firstGroup();
	}

	public function nextGroup(current:String):String {
		if (groups.length == 0) return "";
		for (i in 0...groups.length) {
			if (groups[i].id == current) return groups[(i + 1) % groups.length].id;
		}
		return groups[0].id;
	}

	public function allLessons(groupId:String):Array<Lesson> {
		var src = byGroup.get(groupId);
		return src == null ? [] : src.copy();
	}

	public function dayLessons(groupId:String, day:Int, parity:WeekParity, query:String):Array<Lesson> {
		var out:Array<Lesson> = [];
		for (l in allLessons(groupId)) {
			if (l.day == day && l.parity.matches(parity) && l.matches(query)) out.push(l);
		}
		out.sort((a, b) -> LessonTime.toMinutes(a.start) - LessonTime.toMinutes(b.start));
		return out;
	}

	function addGroup(cfg:GroupConfig):Void {
		groups.push(new GroupInfo(cfg.id, cfg.title));
		var lessons:Array<Lesson> = [];
		for (l in cfg.lessons) lessons.push(new Lesson(cfg.id, l));
		byGroup.set(cfg.id, lessons);
	}
}
