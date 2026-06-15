package game.ui.schedule;

class LessonListRenderer {
	public static function drawToday(k:DrawKit, m:ScheduleScreenModel, x:Float, y:Float, w:Float):Void {
		header(k, m.dayTitle, m.todayCards.length + " занятий", x, y, w);
		k.button("‹ День", x, y + 58, 120, 38, ScheduleAction.ShiftDay(-1));
		k.button("Сегодня", x + 132, y + 58, 120, 38, ScheduleAction.ResetToday, true);
		k.button("День ›", x + 264, y + 58, 120, 38, ScheduleAction.ShiftDay(1));
		drawCards(k, m.todayCards, x, y + 116, w, true);
	}

	public static function drawCards(k:DrawKit, cards:Array<ScheduleCardModel>, x:Float, y:Float, w:Float, timeline:Bool):Float {
		if (cards.length == 0) {
			empty(k, "Занятий нет или фильтр ничего не нашёл", x, y, w);
			return y + 96;
		}
		var cy = y;
		for (c in cards) {
			var h = cardHeight(c);
			if (timeline) timelineMark(k, x + 18, cy + 20, h - 20, c.kindColor);
			drawCard(k, c, timeline ? x + 48 : x, cy, timeline ? w - 48 : w, h);
			cy += h + 14;
		}
		return cy;
	}

	public static function drawCard(k:DrawKit, c:ScheduleCardModel, x:Float, y:Float, w:Float, h:Float):Void {
		k.fill(x + 3, y + 5, w, h, 0x000000, k.theme.shadow, 18);
		k.fill(x, y, w, h, k.theme.panel, 0.98, 18);
		k.fill(x, y, 8, h, c.kindColor, 1, 18);
		k.label(c.time, x + 22, y + 16, 18, k.theme.accent);
		k.label(c.kindLabel, x + w - 76, y + 16, 16, c.kindColor);
		k.label((c.important ? "★ " : "") + c.title, x + 22, y + 42, 24, k.theme.text, w - 112);
		k.label(c.meta, x + 22, y + 76, 16, k.theme.muted, w - 44);
		if (c.note != "") k.label("Заметка: " + c.note, x + 22, y + 104, 16, k.theme.text, w - 44);
		else if (c.expanded) k.label("Подробности: точное время, аудитория и тип занятия показаны в карточке.", x + 22, y + 104, 16, k.theme.muted, w - 44);
		var by = y + h - 40;
		k.button(c.important ? "★ Важное" : "☆ Важное", x + w - 306, by, 138, 32, ScheduleAction.ToggleImportant(c.id), c.important);
		k.button(c.note == "" ? "+ заметка" : "✎ заметка", x + w - 160, by, 138, 32, ScheduleAction.EditNote(c.id));
		k.addHit(x, y, w - 320, h, ScheduleAction.ExpandLesson(c.id));
	}

	static function header(k:DrawKit, title:String, sub:String, x:Float, y:Float, w:Float):Void {
		k.fill(x, y, w, 46, k.theme.panel2, 0.85, 16);
		k.label(title, x + 18, y + 10, 22, k.theme.text);
		k.label(sub, x + w - 160, y + 13, 16, k.theme.muted, 140);
	}

	static function empty(k:DrawKit, text:String, x:Float, y:Float, w:Float):Void {
		k.fill(x, y, w, 84, k.theme.panel, 0.9, 18);
		k.label(text, x + 22, y + 28, 18, k.theme.muted, w - 44);
	}

	static function timelineMark(k:DrawKit, x:Float, y:Float, h:Float, color:Int):Void {
		k.fill(x + 7, y + 12, 4, h, k.theme.panel2, 1, 2);
		k.fill(x, y, 18, 18, color, 1, 9);
	}

	static function cardHeight(c:ScheduleCardModel):Float {
		return c.expanded || c.note != "" ? 156 : 126;
	}
}
