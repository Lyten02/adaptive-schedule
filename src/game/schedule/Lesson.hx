package game.schedule;

class Lesson {
	public var id(default, null):String;
	public var groupId(default, null):String;
	public var day(default, null):Int;
	public var parity(default, null):WeekParity;
	public var start(default, null):String;
	public var end(default, null):String;
	public var title(default, null):String;
	public var teacher(default, null):String;
	public var room(default, null):String;
	public var kind(default, null):LessonKind;

	public function new(groupId:String, cfg:LessonConfig) {
		this.groupId = groupId;
		this.id = groupId + ":" + cfg.id;
		this.day = cfg.day;
		this.parity = WeekParity.parse(cfg.parity);
		this.start = cfg.start;
		this.end = cfg.end;
		this.title = cfg.title;
		this.teacher = cfg.teacher;
		this.room = cfg.room;
		this.kind = LessonKind.parse(cfg.kind);
	}

	public function matches(query:String):Bool {
		if (query == null || StringTools.trim(query) == "") return true;
		var q = query.toLowerCase();
		return title.toLowerCase().indexOf(q) >= 0
			|| teacher.toLowerCase().indexOf(q) >= 0
			|| room.toLowerCase().indexOf(q) >= 0;
	}
}
