package game.schedule;

class GroupInfo {
	public var id(default, null):String;
	public var title(default, null):String;

	public function new(id:String, title:String) {
		this.id = id;
		this.title = title;
	}
}
