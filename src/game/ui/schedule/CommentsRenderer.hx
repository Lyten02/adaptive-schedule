package game.ui.schedule;

class CommentsRenderer {
	public static function draw(k:DrawKit, m:ScheduleScreenModel, x:Float, y:Float, w:Float):Void {
		k.label("Все локальные комментарии", x, y, 24, k.theme.text);
		k.label("Хранятся только на этом устройстве и не отправляются наружу.", x, y + 34, 17, k.theme.muted, w);
		if (m.comments.length == 0) {
			k.fill(x, y + 82, w, 94, k.theme.panel, 0.95, 18);
			k.label("Пока нет заметок. Откройте карточку пары и нажмите «+ заметка».", x + 22, y + 112, 18, k.theme.muted, w - 44);
			return;
		}
		var cy = y + 82;
		for (c in m.comments) {
			k.fill(x, cy, w, 112, k.theme.panel, 0.96, 18);
			k.label(c.title, x + 20, cy + 14, 21, k.theme.text, w - 40);
			k.label(c.meta, x + 20, cy + 44, 16, k.theme.muted, w - 40);
			k.label(c.note, x + 20, cy + 72, 17, k.theme.text, w - 176);
			k.button("изменить", x + w - 144, cy + 62, 122, 34, ScheduleAction.EditNote(c.lessonId));
			cy += 128;
		}
	}
}
