package game.ui.schedule;

enum ScheduleAction {
	None;
	SelectTab(tab:ScheduleTab);
	SelectGroup(id:String);
	SelectCompareGroup(id:String);
	ShiftDay(delta:Int);
	ShiftWeek(delta:Int);
	ResetToday;
	ToggleTheme;
	ToggleReminder;
	ToggleImportant(lessonId:String);
	EditNote(lessonId:String);
	ExpandLesson(lessonId:String);
	Search;
	ClearSearch;
	Fullscreen;
	OpenWindow;
}
