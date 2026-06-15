package game.schedule;

enum abstract WeekParity(String) from String to String {
	var Both = "both";
	var Odd = "odd";
	var Even = "even";

	public static function parse(value:String):WeekParity {
		return switch (value) {
			case "odd": Odd;
			case "even": Even;
			default: Both;
		}
	}

	public inline function matches(current:WeekParity):Bool {
		return this == Both || this == current;
	}

	public function label():String {
		return switch (this) {
			case Odd: "нечётная";
			case Even: "чётная";
			default: "каждая";
		}
	}
}
