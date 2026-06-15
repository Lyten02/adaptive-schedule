package game.ui.schedule;

enum abstract ScheduleTab(String) from String to String {
	var Today = "today";
	var Week = "week";
	var Compare = "compare";
	var Comments = "comments";

	public static function parse(value:String):ScheduleTab {
		return switch (value) {
			case "week": Week;
			case "compare": Compare;
			case "comments": Comments;
			default: Today;
		}
	}

	public function label():String {
		return switch (this) {
			case Week: "Неделя";
			case Compare: "Сравнение";
			case Comments: "Комментарии";
			default: "Сегодня";
		}
	}
}
