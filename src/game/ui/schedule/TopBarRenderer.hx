package game.ui.schedule;

class TopBarRenderer {
	public static function draw(k:DrawKit, m:ScheduleScreenModel, w:Float):Float {
		if (w < 520) return drawCompact(k, m, w);
		return drawWide(k, m, w);
	}

	static function drawWide(k:DrawKit, m:ScheduleScreenModel, w:Float):Float {
		var pad = 22.0;
		k.label("Умное расписание", pad, 16, 34, k.theme.text);
		k.label(m.groupTitle + " - " + m.weekLabel, pad, 56, 17, k.theme.muted, w - pad * 2);

		var x = pad;
		var y = 86.0;
		var toolsInline = w > 1180;
		x += tab(k, "Сегодня", ScheduleTab.Today, m.tab, x, y) + 8;
		x += tab(k, "Неделя", ScheduleTab.Week, m.tab, x, y) + 8;
		x += tab(k, "Сравнить", ScheduleTab.Compare, m.tab, x, y) + 8;
		x += tab(k, "Заметки", ScheduleTab.Comments, m.tab, x, y) + 16;
		if (w > 860) {
			x += k.chip("день: +/-", x, y, ScheduleAction.None) + 8;
			x += k.chip("неделя: +/-", x, y, ScheduleAction.None) + 8;
		}
		if (toolsInline) drawTools(k, m, w - 538, y, 516, false);

		var gy = 136.0;
		drawGroups(k, m, pad, gy, w - pad * 2, false);
		if (!toolsInline) drawTools(k, m, pad, 184, w - pad * 2, false);
		return toolsInline ? 188 : 236;
	}

	static function drawCompact(k:DrawKit, m:ScheduleScreenModel, w:Float):Float {
		var pad = 12.0;
		var maxW = w - pad * 2;
		k.label("Умное расписание", pad, 10, 26, k.theme.text, maxW);
		k.label(m.groupTitle + " - " + m.weekLabel, pad, 42, 14, k.theme.muted, maxW);

		var y = 68.0;
		drawTabsCompact(k, m, pad, y, maxW);
		y += 42;
		y += drawGroups(k, m, pad, y, maxW, true) + 6;
		y += drawTools(k, m, pad, y, maxW, true) + 8;
		return y;
	}

	static function drawTabsCompact(k:DrawKit, m:ScheduleScreenModel, x:Float, y:Float, w:Float):Void {
		var gap = 6.0;
		var tabW = (w - gap * 3) / 4;
		fixedTab(k, "Сегодня", ScheduleTab.Today, m.tab, x, y, tabW);
		fixedTab(k, "Неделя", ScheduleTab.Week, m.tab, x + (tabW + gap), y, tabW);
		fixedTab(k, "Срав.", ScheduleTab.Compare, m.tab, x + (tabW + gap) * 2, y, tabW);
		fixedTab(k, "Замет.", ScheduleTab.Comments, m.tab, x + (tabW + gap) * 3, y, tabW);
	}

	static function fixedTab(k:DrawKit, text:String, tab:ScheduleTab, current:ScheduleTab, x:Float, y:Float, w:Float):Void {
		k.button(text, x, y, w, 34, ScheduleAction.SelectTab(tab), tab == current);
	}

	static function tab(k:DrawKit, text:String, tab:ScheduleTab, current:ScheduleTab, x:Float, y:Float):Float {
		var width = text.length * 10 + 34;
		k.button(text, x, y, width, 40, ScheduleAction.SelectTab(tab), tab == current);
		return width;
	}

	static function drawGroups(k:DrawKit, m:ScheduleScreenModel, x:Float, y:Float, maxW:Float, compact:Bool):Float {
		var rowH = compact ? 34.0 : 38.0;
		var minW = compact ? 76.0 : 92.0;
		var gap = compact ? 6.0 : 8.0;
		var gx = compact ? x : x + 112;
		var gy = compact ? y + 24 : y;
		k.label("Моя группа", x, y + (compact ? 2 : 8), compact ? 14 : 16, k.theme.muted);
		for (g in m.groups) {
			var cw = k.chipWidth(g.id, minW);
			if (gx > x && gx + cw > x + maxW) { gx = x; gy += rowH + gap; }
			gx += k.chip(g.id, gx, gy, ScheduleAction.SelectGroup(g.id), g.id == m.groupId, minW, rowH) + gap;
		}
		return gy - y + rowH;
	}

	static function drawTools(k:DrawKit, m:ScheduleScreenModel, x:Float, y:Float, maxW:Float, compact:Bool):Float {
		var rowH = compact ? 34.0 : 38.0;
		var minW = compact ? 76.0 : 92.0;
		var gap = compact ? 6.0 : 8.0;
		var tx = x;
		tx += k.chip(m.theme.label(), tx, y, ScheduleAction.ToggleTheme, false, minW, rowH) + gap;
		if (m.query == "") tx += k.chip("Поиск", tx, y, ScheduleAction.Search, false, minW, rowH) + gap;
		else tx += k.chip("Сброс", tx, y, ScheduleAction.ClearSearch, true, minW, rowH) + gap;
		tx += k.chip(compact ? "Напом." : (m.remindersEnabled ? "30 мин" : "Напоминания"), tx, y, ScheduleAction.ToggleReminder, m.remindersEnabled, minW, rowH) + gap;
		if (!compact) {
			if (m.query != "" && tx + 92 < x + maxW) tx += k.chip(shortText(m.query, 16), tx, y, ScheduleAction.Search, true) + gap;
			if (tx + 112 < x + maxW) tx += k.chip("Fullscreen", tx, y, ScheduleAction.Fullscreen) + gap;
			if (tx + 118 < x + maxW) k.chip("Новое окно", tx, y, ScheduleAction.OpenWindow);
		}
		return rowH;
	}

	static function shortText(text:String, max:Int):String {
		return text.length > max ? text.substr(0, max) + "..." : text;
	}
}
