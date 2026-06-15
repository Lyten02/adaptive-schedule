package game.ui.schedule;

class DrawHit {
	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;
	public var action:ScheduleAction;

	public function new(x:Float, y:Float, w:Float, h:Float, action:ScheduleAction) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.action = action;
	}

	public inline function contains(px:Float, py:Float):Bool {
		return px >= x && py >= y && px <= x + w && py <= y + h;
	}
}
