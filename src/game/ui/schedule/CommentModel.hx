package game.ui.schedule;

class CommentModel {
	public var lessonId:String;
	public var title:String;
	public var meta:String;
	public var note:String;

	public function new(lessonId:String, title:String, meta:String, note:String) {
		this.lessonId = lessonId;
		this.title = title;
		this.meta = meta;
		this.note = note;
	}
}
