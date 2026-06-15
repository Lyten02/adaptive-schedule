package game.ui.schedule;

class CompareRenderer {
	public static function draw(k:DrawKit, m:ScheduleScreenModel, x:Float, y:Float, w:Float):Void {
		k.label("Сравнение групп бок о бок", x, y, 24, k.theme.text);
		var gx = x;
		for (g in m.groups) gx += k.chip(g.id, gx, y + 40, ScheduleAction.SelectCompareGroup(g.id), g.id == m.compareGroupId) + 8;
		var top = y + 96;
		if (w < 820) {
			var mid = drawPanel(k, m.groupTitle, m.todayCards, x, top, w);
			drawPanel(k, m.compareGroupTitle, m.compareCards, x, mid + 16, w);
		} else {
			var gap = 18.0;
			var col = (w - gap) * 0.5;
			drawPanel(k, m.groupTitle, m.todayCards, x, top, col);
			drawPanel(k, m.compareGroupTitle, m.compareCards, x + col + gap, top, col);
		}
	}

	static function drawPanel(k:DrawKit, title:String, cards:Array<ScheduleCardModel>, x:Float, y:Float, w:Float):Float {
		k.fill(x, y, w, 54, k.theme.panel2, 0.95, 16);
		k.label(title, x + 18, y + 14, 22, k.theme.text, w - 36);
		return LessonListRenderer.drawCards(k, cards, x, y + 72, w, false);
	}
}
