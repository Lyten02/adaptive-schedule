package game.ui.schedule;

class UiTheme {
	public var bg:Int;
	public var panel:Int;
	public var panel2:Int;
	public var text:Int;
	public var muted:Int;
	public var accent:Int;
	public var danger:Int;
	public var shadow:Float;

	public function new(mode:ThemeMode) {
		if (mode == ThemeMode.Light) {
			bg = 0xf4f7fb; panel = 0xffffff; panel2 = 0xeaf0fb;
			text = 0x172033; muted = 0x61708a; accent = 0x315dff;
			danger = 0xe6505d; shadow = 0.12;
		} else {
			bg = 0x101525; panel = 0x182033; panel2 = 0x242e45;
			text = 0xf4f7ff; muted = 0xaeb9cf; accent = 0x76a7ff;
			danger = 0xff7080; shadow = 0.28;
		}
	}
}
