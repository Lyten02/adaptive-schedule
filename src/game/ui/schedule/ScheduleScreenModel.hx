package game.ui.schedule;

import game.schedule.GroupInfo;

class ScheduleScreenModel {
	public var tab:ScheduleTab = ScheduleTab.Today;
	public var theme:ThemeMode = ThemeMode.Dark;
	public var groups:Array<GroupInfo> = [];
	public var groupId:String = "";
	public var groupTitle:String = "";
	public var compareGroupId:String = "";
	public var compareGroupTitle:String = "";
	public var dayTitle:String = "";
	public var weekLabel:String = "";
	public var query:String = "";
	public var onboarding:Bool = false;
	public var remindersEnabled:Bool = false;
	public var todayCards:Array<ScheduleCardModel> = [];
	public var compareCards:Array<ScheduleCardModel> = [];
	public var weekDays:Array<DayColumnModel> = [];
	public var comments:Array<CommentModel> = [];
	public var message:String = "";

	public function new() {}
}
