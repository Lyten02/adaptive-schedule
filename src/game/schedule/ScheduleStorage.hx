package game.schedule;

class ScheduleStorage {
	static inline var PREFIX = "smartSchedule.";
	static var memory:Map<String, String> = new Map();

	public static function getString(key:String, fallback:String):String {
		var v = read(key);
		return v == null ? fallback : v;
	}

	public static function setString(key:String, value:String):Void write(key, value);
	public static function remove(key:String):Void write(key, null);

	public static function bool(key:String, fallback:Bool):Bool {
		var v = read(key);
		return v == null ? fallback : v == "1";
	}

	public static function setBool(key:String, value:Bool):Void write(key, value ? "1" : "0");
	public static function noteKey(id:String):String return "note." + id;
	public static function importantKey(id:String):String return "important." + id;

	static function read(key:String):Null<String> {
		#if (js && !nodejs)
		try return js.Browser.window.localStorage.getItem(PREFIX + key) catch (e:Dynamic) return null;
		#else
		return memory.get(PREFIX + key);
		#end
	}

	static function write(key:String, value:Null<String>):Void {
		#if (js && !nodejs)
		try {
			if (value == null) js.Browser.window.localStorage.removeItem(PREFIX + key);
			else js.Browser.window.localStorage.setItem(PREFIX + key, value);
		} catch (e:Dynamic) {}
		#else
		if (value == null) memory.remove(PREFIX + key) else memory.set(PREFIX + key, value);
		#end
	}
}
