package game.ui.schedule;

class DayColumnModel {
	public var title:String;
	public var cards:Array<ScheduleCardModel>;

	public function new(title:String, cards:Array<ScheduleCardModel>) {
		this.title = title;
		this.cards = cards;
	}
}
