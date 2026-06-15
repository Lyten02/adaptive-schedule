package game.schedule;

class WeekCalendar {
	static inline var DAY_MS:Float = 86400000;
	static inline var WEEK_MS:Float = DAY_MS * 7;

	public static function dayIndex(date:Date):Int {
		return (date.getDay() + 6) % 7;
	}

	public static function dayTitle(index:Int):String {
		return switch ((index % 7 + 7) % 7) {
			case 0: "Понедельник";
			case 1: "Вторник";
			case 2: "Среда";
			case 3: "Четверг";
			case 4: "Пятница";
			case 5: "Суббота";
			default: "Воскресенье";
		}
	}

	public static function shortDayTitle(index:Int):String {
		return dayTitle(index).substr(0, 2);
	}

	public static function weekNumber(date:Date):Int {
		var jan4 = new Date(date.getFullYear(), 0, 4, 12, 0, 0);
		var firstMonday = mondayMs(jan4);
		return Math.floor((mondayMs(date) - firstMonday) / WEEK_MS) + 1;
	}

	public static function parity(date:Date):WeekParity {
		return weekNumber(date) % 2 == 0 ? WeekParity.Even : WeekParity.Odd;
	}

	static function mondayMs(date:Date):Float {
		return noonMs(date) - dayIndex(date) * DAY_MS;
	}

	static function noonMs(date:Date):Float {
		return new Date(date.getFullYear(), date.getMonth(), date.getDate(), 12, 0, 0).getTime();
	}
}
