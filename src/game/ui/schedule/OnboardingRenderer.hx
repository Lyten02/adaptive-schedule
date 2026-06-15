package game.ui.schedule;

class OnboardingRenderer {
	public static function draw(k:DrawKit, m:ScheduleScreenModel, w:Float, h:Float):Void {
		k.fill(0, 0, w, h, 0x000000, 0.55);
		var mw = Math.min(620, w - 44);
		var mh = 330.0;
		var x = (w - mw) * 0.5;
		var y = (h - mh) * 0.5;
		k.fill(x, y, mw, mh, k.theme.panel, 1, 24);
		k.label("Первый запуск", x + 30, y + 28, 30, k.theme.text);
		k.label("Выберите свою группу - приложение запомнит её локально.", x + 30, y + 72, 18, k.theme.muted, mw - 60);
		var gx = x + 30;
		var gy = y + 126;
		for (g in m.groups) {
			var used = gx + 118 > x + mw - 30;
			if (used) { gx = x + 30; gy += 52; }
			gx += k.chip(g.id, gx, gy, ScheduleAction.SelectGroup(g.id), g.id == m.groupId) + 10;
		}
		k.label("Дальше можно открыть вкладки: Сегодня, Неделя, Сравнение и Комментарии.", x + 30, y + mh - 74, 17, k.theme.muted, mw - 60);
	}
}
