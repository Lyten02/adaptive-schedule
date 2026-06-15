package game.ui.schedule;

import h2d.Interactive;
import h2d.Object;

class ScheduleView {
	public var root(default, null):Object;
	public var interactive(default, null):Interactive;
	var kit:DrawKit;
	var width:Float = 1;
	var height:Float = 1;

	public function new(parent:Object) {
		root = new Object(parent);
		kit = new DrawKit(root);
		interactive = new Interactive(1, 1, parent);
	}

	public function resize(w:Float, h:Float):Bool {
		var nextW = Math.max(1, w);
		var nextH = Math.max(1, h);
		var changed = nextW != width || nextH != height;
		width = nextW;
		height = nextH;
		interactive.width = width;
		interactive.height = height;
		return changed;
	}

	public function render(m:ScheduleScreenModel):Void {
		var theme = new UiTheme(m.theme);
		kit.begin(theme);
		kit.fill(0, 0, width, height, theme.bg);
		var top = TopBarRenderer.draw(kit, m, width);
		var pad = width < 700 ? 14.0 : 24.0;
		var contentW = width - pad * 2;
		switch (m.tab) {
			case ScheduleTab.Today:
				LessonListRenderer.drawToday(kit, m, pad, top, contentW);
			case ScheduleTab.Week:
				WeekRenderer.draw(kit, m, pad, top, contentW);
			case ScheduleTab.Compare:
				CompareRenderer.draw(kit, m, pad, top, contentW);
			case ScheduleTab.Comments:
				CommentsRenderer.draw(kit, m, pad, top, contentW);
		}
		footer(m);
		if (m.onboarding) OnboardingRenderer.draw(kit, m, width, height);
	}

	public function actionAt(x:Float, y:Float):ScheduleAction {
		var i = kit.hits.length - 1;
		while (i >= 0) {
			var h = kit.hits[i];
			if (h.contains(x, y)) return h.action;
			i--;
		}
		return ScheduleAction.None;
	}

	public function dispose():Void {
		if (interactive != null) { interactive.remove(); interactive = null; }
		if (root != null) { root.remove(); root = null; }
	}

	function footer(m:ScheduleScreenModel):Void {
		var text = width < 520
			? "Свайп: день/неделя - F fullscreen - / поиск"
			: "Свайпайте на телефоне - стрелки на ПК - F fullscreen - / поиск - N новое окно";
		if (m.message != "") text = m.message;
		kit.label(text, 22, height - 28, 15, kit.theme.muted, width - 44);
	}
}
