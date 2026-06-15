package game.ui.schedule;

class TopBarRenderer {
	public static function draw(k:DrawKit, m:ScheduleScreenModel, w:Float):Float {
		var pad = 22.0;
		k.label("Умное расписание", pad, 16, 34, k.theme.text);
		k.label(m.groupTitle + " • " + m.weekLabel, pad, 56, 17, k.theme.muted, w - pad * 2);

		var x = pad;
		var y = 86.0;
		x += tab(k, "Сегодня", ScheduleTab.Today, m.tab, x, y) + 8;
		x += tab(k, "Неделя", ScheduleTab.Week, m.tab, x, y) + 8;
		x += tab(k, "Сравнить", ScheduleTab.Compare, m.tab, x, y) + 8;
		x += tab(k, "Заметки", ScheduleTab.Comments, m.tab, x, y) + 16;
		x += k.chip("←/→ день", x, y, ScheduleAction.None) + 8;
		x += k.chip("↑/↓ неделя", x, y, ScheduleAction.None) + 8;
		if (w > 900) drawTools(k, m, w - 538, y, 516);

		var gy = 136.0;
		k.label("Моя группа", pad, gy + 8, 16, k.theme.muted);
		var gx = pad + 112;
		for (g in m.groups) {
			gx += k.chip(g.id, gx, gy, ScheduleAction.SelectGroup(g.id), g.id == m.groupId) + 8;
		}
		if (w <= 900) drawTools(k, m, pad, 184, w - pad * 2);
		return w <= 900 ? 236 : 188;
	}

	static function tab(k:DrawKit, text:String, tab:ScheduleTab, current:ScheduleTab, x:Float, y:Float):Float {
		var width = text.length * 10 + 34;
		k.button(text, x, y, width, 40, ScheduleAction.SelectTab(tab), tab == current);
		return width;
	}

	static function drawTools(k:DrawKit, m:ScheduleScreenModel, x:Float, y:Float, maxW:Float):Void {
		var tx = x;
		tx += k.chip(m.theme.label(), tx, y, ScheduleAction.ToggleTheme) + 8;
		tx += k.chip("Поиск", tx, y, ScheduleAction.Search, m.query != "") + 8;
		if (m.query != "") tx += k.chip("× " + m.query, tx, y, ScheduleAction.ClearSearch) + 8;
		tx += k.chip(m.remindersEnabled ? "30 мин" : "Напоминания", tx, y, ScheduleAction.ToggleReminder) + 8;
		if (tx + 112 < x + maxW) tx += k.chip("Fullscreen", tx, y, ScheduleAction.Fullscreen) + 8;
		if (tx + 118 < x + maxW) k.chip("Новое окно", tx, y, ScheduleAction.OpenWindow);
	}
}
