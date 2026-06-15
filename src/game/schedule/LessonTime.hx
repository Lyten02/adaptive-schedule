package game.schedule;

class LessonTime {
	public static function toMinutes(value:String):Int {
		var parts = value.split(":");
		if (parts.length != 2) return 0;
		var h = Std.parseInt(parts[0]);
		var m = Std.parseInt(parts[1]);
		if (h == null || m == null) return 0;
		return h * 60 + m;
	}

	public static inline function range(start:String, end:String):String {
		return start + "-" + end;
	}

	public static function minutesUntil(now:Date, start:String):Int {
		var current = now.getHours() * 60 + now.getMinutes();
		return toMinutes(start) - current;
	}

	public static function isActive(now:Date, start:String, end:String):Bool {
		var current = now.getHours() * 60 + now.getMinutes();
		return current >= toMinutes(start) && current <= toMinutes(end);
	}
}
