package game.ui.schedule;

import h2d.Graphics;
import h2d.Object;
import h2d.Text;
import loc.text.font.FontRegistry;

class DrawKit {
	public var root(default, null):Object;
	public var hits(default, null):Array<DrawHit> = [];
	public var theme(default, null):UiTheme;
	var g:Graphics;

	public function new(root:Object) {
		this.root = root;
	}

	public function begin(theme:UiTheme):Void {
		this.theme = theme;
		root.removeChildren();
		hits = [];
		g = new Graphics(root);
	}

	public function fill(x:Float, y:Float, w:Float, h:Float, color:Int, alpha:Float = 1, radius:Float = 0):Void {
		g.beginFill(color, alpha);
		g.drawRoundedRect(x, y, w, h, radius);
		g.endFill();
	}

	public function stroke(x:Float, y:Float, w:Float, h:Float, color:Int, alpha:Float = 1, radius:Float = 0):Void {
		g.lineStyle(1, color, alpha);
		g.drawRoundedRect(x, y, w, h, radius);
		g.lineStyle(0);
	}

	public function label(text:String, x:Float, y:Float, size:Int, color:Int, ?maxWidth:Float):Text {
		var t = new Text(FontRegistry.get(size), root);
		t.text = text;
		t.textColor = color;
		t.smooth = true;
		if (maxWidth != null) t.maxWidth = maxWidth;
		t.x = Math.round(x);
		t.y = Math.round(y);
		return t;
	}

	public function button(text:String, x:Float, y:Float, w:Float, h:Float, action:ScheduleAction, active:Bool = false):Void {
		fill(x, y, w, h, active ? theme.accent : theme.panel2, active ? 0.98 : 0.9, 14);
		var t = label(text, x, y + (h - 18) * 0.5, 18, active ? 0xffffff : theme.text, w);
		t.textAlign = h2d.Align.Center;
		hits.push(new DrawHit(x, y, w, h, action));
	}

	public function chip(text:String, x:Float, y:Float, action:ScheduleAction, active:Bool = false):Float {
		var w = Math.max(92, text.length * 10 + 28);
		button(text, x, y, w, 38, action, active);
		return w;
	}

	public function addHit(x:Float, y:Float, w:Float, h:Float, action:ScheduleAction):Void {
		hits.push(new DrawHit(x, y, w, h, action));
	}
}
