package game.schedule;

import utest.Assert;
import utest.Test;

class ScheduleRepositorySpec extends Test {
	static inline var JSON = '{"groups":[{"id":"A-1","title":"Группа A","lessons":[{"id":"alg","day":0,"parity":"both","start":"10:45","end":"12:15","title":"Алгоритмы","teacher":"Иванов","room":"101","kind":"practice"},{"id":"math","day":0,"parity":"odd","start":"09:00","end":"10:30","title":"Математика","teacher":"Петров","room":"202","kind":"lecture"}]}]}';

	public function testFiltersByParityAndSortsByTime() {
		var repo = ScheduleRepository.parse(JSON);
		var lessons = repo.dayLessons("A-1", 0, WeekParity.Odd, "");
		Assert.equals(2, lessons.length);
		Assert.equals("Математика", lessons[0].title);
		Assert.equals("Алгоритмы", lessons[1].title);
	}

	public function testSearchMatchesTeacherAndRoom() {
		var repo = ScheduleRepository.parse(JSON);
		Assert.equals(1, repo.dayLessons("A-1", 0, WeekParity.Odd, "иванов").length);
		Assert.equals(1, repo.dayLessons("A-1", 0, WeekParity.Odd, "202").length);
	}
}
