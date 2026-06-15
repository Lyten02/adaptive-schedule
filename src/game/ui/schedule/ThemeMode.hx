package game.ui.schedule;

enum abstract ThemeMode(String) from String to String {
	var Dark = "dark";
	var Light = "light";

	public static function parse(value:String):ThemeMode {
		return value == "light" ? Light : Dark;
	}

	public function toggle():ThemeMode {
		return this == Dark ? Light : Dark;
	}

	public function label():String {
		return this == Dark ? "Тёмная" : "Светлая";
	}
}
