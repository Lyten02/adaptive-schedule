package game.ui.schedule;

class WeekRenderer {
	public static function draw(k:DrawKit, m:ScheduleScreenModel, x:Float, y:Float, w:Float):Void {
		k.button("‹ Неделя", x, y, 132, 38, ScheduleAction.ShiftWeek(-1));
		k.button("Текущая", x + 144, y, 132, 38, ScheduleAction.ResetToday, true);
		k.button("Неделя ›", x + 288, y, 132, 38, ScheduleAction.ShiftWeek(1));
		var top = y + 58;
		if (w < 760) drawStack(k, m, x, top, w) else drawColumns(k, m, x, top, w);
	}

	static function drawColumns(k:DrawKit, m:ScheduleScreenModel, x:Float, y:Float, w:Float):Void {
		var gap = 10.0;
		var colW = (w - gap * (m.weekDays.length - 1)) / m.weekDays.length;
		var cx = x;
		for (d in m.weekDays) {
			dayPanel(k, d, cx, y, colW, true);
			cx += colW + gap;
		}
	}

	static function drawStack(k:DrawKit, m:ScheduleScreenModel, x:Float, y:Float, w:Float):Void {
		var cy = y;
		for (d in m.weekDays) cy = dayPanel(k, d, x, cy, w, false) + 12;
	}

	static function dayPanel(k:DrawKit, d:DayColumnModel, x:Float, y:Float, w:Float, compact:Bool):Float {
		var h = compact ? 430.0 : Math.max(132, 70 + d.cards.length * 62);
		k.fill(x, y, w, h, k.theme.panel, 0.96, 18);
		k.label(d.title, x + 14, y + 12, 18, k.theme.text, w - 28);
		if (d.cards.length == 0) {
			k.label("окон нет", x + 14, y + 48, 15, k.theme.muted, w - 28);
			return y + h;
		}
		var cy = y + 48;
		for (c in d.cards) {
			if (cy + 56 > y + h) {
				k.label("…", x + 14, cy, 18, k.theme.muted);
				break;
			}
			miniCard(k, c, x + 12, cy, w - 24);
			cy += 62;
		}
		return y + h;
	}

	static function miniCard(k:DrawKit, c:ScheduleCardModel, x:Float, y:Float, w:Float):Void {
		k.fill(x, y, w, 54, k.theme.panel2, 0.95, 12);
		k.fill(x, y, 5, 54, c.kindColor, 1, 10);
		k.label(c.time, x + 12, y + 8, 14, k.theme.accent, w - 24);
		k.label((c.important ? "★ " : "") + c.title, x + 12, y + 28, 15, k.theme.text, w - 24);
		k.addHit(x, y, w, 54, ScheduleAction.ExpandLesson(c.id));
	}
}
