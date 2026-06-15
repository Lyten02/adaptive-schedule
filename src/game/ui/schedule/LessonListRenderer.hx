package game.ui.schedule;

class LessonListRenderer {
	public static function drawToday(k:DrawKit, m:ScheduleScreenModel, x:Float, y:Float, w:Float):Void {
		var compact = w < 420;
		var headerH = header(k, m.dayTitle, m.todayCards.length + " занятий", x, y, w, compact);
		var navY = y + headerH + 10;
		if (compact) {
			var gap = 6.0;
			var bw = (w - gap * 2) / 3;
			k.button("Назад", x, navY, bw, 34, ScheduleAction.ShiftDay(-1));
			k.button("Сегодня", x + bw + gap, navY, bw, 34, ScheduleAction.ResetToday, true);
			k.button("Далее", x + (bw + gap) * 2, navY, bw, 34, ScheduleAction.ShiftDay(1));
			drawCards(k, m.todayCards, x, navY + 48, w, true);
		} else {
			k.button("< День", x, navY, 120, 38, ScheduleAction.ShiftDay(-1));
			k.button("Сегодня", x + 132, navY, 120, 38, ScheduleAction.ResetToday, true);
			k.button("День >", x + 264, navY, 120, 38, ScheduleAction.ShiftDay(1));
			drawCards(k, m.todayCards, x, navY + 58, w, true);
		}
	}

	public static function drawCards(k:DrawKit, cards:Array<ScheduleCardModel>, x:Float, y:Float, w:Float, timeline:Bool):Float {
		if (cards.length == 0) {
			empty(k, "Занятий нет или фильтр ничего не нашёл", x, y, w);
			return y + 96;
		}
		var cy = y;
		for (c in cards) {
			var compactLine = timeline && w < 420;
			var cardX = timeline ? x + (compactLine ? 28 : 48) : x;
			var cardW = timeline ? w - (compactLine ? 28 : 48) : w;
			var h = cardHeight(c, cardW);
			if (timeline) timelineMark(k, x + (compactLine ? 8 : 18), cy + 20, h - 20, c.kindColor);
			drawCard(k, c, cardX, cy, cardW, h);
			cy += h + 14;
		}
		return cy;
	}

	public static function drawCard(k:DrawKit, c:ScheduleCardModel, x:Float, y:Float, w:Float, h:Float):Void {
		var compact = w < 430;
		k.fill(x + 3, y + 5, w, h, 0x000000, k.theme.shadow, 18);
		k.fill(x, y, w, h, k.theme.panel, 0.98, 18);
		k.fill(x, y, 8, h, c.kindColor, 1, 18);
		k.label(c.time, x + 22, y + 16, compact ? 16 : 18, k.theme.accent);
		k.label(c.kindLabel, x + w - 78, y + 16, compact ? 14 : 16, c.kindColor, 70);
		var title = (c.important ? "Важно: " : "") + c.title;
		k.label(title, x + 22, y + 42, compact ? 21 : 24, k.theme.text, compact ? w - 44 : w - 112);
		k.label(c.meta, x + 22, y + 76, compact ? 15 : 16, k.theme.muted, w - 44);
		if (c.note != "") k.label("Заметка: " + c.note, x + 22, y + 104, 16, k.theme.text, w - 44);
		else if (c.expanded) k.label("Подробности: время, аудитория и тип занятия показаны в карточке.", x + 22, y + 104, 16, k.theme.muted, w - 44);
		drawCardButtons(k, c, x, y, w, h, compact);
	}

	static function drawCardButtons(k:DrawKit, c:ScheduleCardModel, x:Float, y:Float, w:Float, h:Float, compact:Bool):Void {
		var by = y + h - 40;
		if (compact) {
			var gap = 8.0;
			var bw = (w - 44 - gap) * 0.5;
			by = y + h - 38;
			k.button("Важно", x + 22, by, bw, 32, ScheduleAction.ToggleImportant(c.id), c.important);
			k.button(c.note == "" ? "+ заметка" : "заметка", x + 22 + bw + gap, by, bw, 32, ScheduleAction.EditNote(c.id));
			k.addHit(x, y, w, h - 44, ScheduleAction.ExpandLesson(c.id));
		} else {
			k.button(c.important ? "Важное" : "Важно", x + w - 306, by, 138, 32, ScheduleAction.ToggleImportant(c.id), c.important);
			k.button(c.note == "" ? "+ заметка" : "заметка", x + w - 160, by, 138, 32, ScheduleAction.EditNote(c.id));
			k.addHit(x, y, Math.max(1, w - 320), h, ScheduleAction.ExpandLesson(c.id));
		}
	}

	static function header(k:DrawKit, title:String, sub:String, x:Float, y:Float, w:Float, compact:Bool):Float {
		var h = compact ? 52.0 : 46.0;
		k.fill(x, y, w, h, k.theme.panel2, 0.85, 16);
		k.label(title, x + 18, y + (compact ? 7 : 10), compact ? 20 : 22, k.theme.text, w - 36);
		if (compact) k.label(sub, x + 18, y + 31, 14, k.theme.muted, w - 36);
		else k.label(sub, x + w - 160, y + 13, 16, k.theme.muted, 140);
		return h;
	}

	static function empty(k:DrawKit, text:String, x:Float, y:Float, w:Float):Void {
		k.fill(x, y, w, 84, k.theme.panel, 0.9, 18);
		k.label(text, x + 22, y + 28, 18, k.theme.muted, w - 44);
	}

	static function timelineMark(k:DrawKit, x:Float, y:Float, h:Float, color:Int):Void {
		k.fill(x + 7, y + 12, 4, h, k.theme.panel2, 1, 2);
		k.fill(x, y, 18, 18, color, 1, 9);
	}

	static function cardHeight(c:ScheduleCardModel, w:Float):Float {
		if (w < 430) return c.expanded || c.note != "" ? 174 : 144;
		return c.expanded || c.note != "" ? 156 : 126;
	}
}
