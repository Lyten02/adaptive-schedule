package game.schedule;

enum abstract LessonKind(String) from String to String {
	var Lecture = "lecture";
	var Practice = "practice";
	var Exam = "exam";
	var Credit = "credit";

	public static function parse(value:String):LessonKind {
		return switch (value) {
			case "practice": Practice;
			case "exam": Exam;
			case "credit": Credit;
			default: Lecture;
		}
	}

	public function label():String {
		return switch (this) {
			case Practice: "Практика";
			case Exam: "Экзамен";
			case Credit: "Зачёт";
			default: "Лекция";
		}
	}

	public function badge():String {
		return switch (this) {
			case Practice: "ПР";
			case Exam: "ЭКЗ";
			case Credit: "ЗАЧ";
			default: "ЛК";
		}
	}

	public function color():Int {
		return switch (this) {
			case Practice: 0x28c76f;
			case Exam: 0xff5f6d;
			case Credit: 0xffb020;
			default: 0x4d8dff;
		}
	}
}
