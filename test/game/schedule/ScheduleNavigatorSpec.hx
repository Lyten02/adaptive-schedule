package game.schedule;

import utest.Assert;
import utest.Test;

class ScheduleNavigatorSpec extends Test {
	public function testTodayStartsFromGivenDate() {
		var nav = new ScheduleNavigator(new Date(2026, 0, 5, 12, 0, 0));
		Assert.equals(0, nav.selectedDay());
		Assert.equals("Понедельник", nav.dayTitle());
	}

	public function testDayAndWeekShiftsAffectSelectedDay() {
		var nav = new ScheduleNavigator(new Date(2026, 0, 5, 12, 0, 0));
		nav.shiftDays(2);
		Assert.equals(2, nav.selectedDay());
		nav.shiftWeeks(1);
		Assert.equals(2, nav.selectedDay());
	}
}
