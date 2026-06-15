package game.ui.schedule;

import game.schedule.BrowserActions;
import game.schedule.Lesson;
import game.schedule.LessonTime;
import game.schedule.ReminderService;
import game.schedule.ScheduleNavigator;
import game.schedule.ScheduleRepository;
import game.schedule.ScheduleStorage;
import game.schedule.WeekCalendar;

class SchedulePresenter {
	var view:ScheduleView;
	var repo:ScheduleRepository;
	var nav:ScheduleNavigator;
	var reminders:ReminderService;
	var tab:ScheduleTab;
	var theme:ThemeMode;
	var groupId:String;
	var compareGroupId:String;
	var query:String = "";
	var expandedId:String = "";
	var onboarding:Bool;
	var reminderOn:Bool;
	var dirty:Bool = true;

	public function new(view:ScheduleView, repo:ScheduleRepository) {
		this.view = view;
		this.repo = repo;
		nav = new ScheduleNavigator();
		reminders = new ReminderService(repo);
		var hashTab = BrowserActions.hashTab();
		tab = ScheduleTab.parse(hashTab == "" ? "today" : hashTab);
		theme = ThemeMode.parse(ScheduleStorage.getString("theme", "dark"));
		var saved = ScheduleStorage.getString("group", "");
		onboarding = saved == "";
		groupId = repo.safeGroup(onboarding ? repo.firstGroup() : saved);
		compareGroupId = repo.safeGroup(ScheduleStorage.getString("compareGroup", repo.nextGroup(groupId)));
		reminderOn = ScheduleStorage.bool("reminders", false);
	}

	public function update(dt:Float):Void {
		reminders.tick(groupId, reminderOn, 30);
		if (dirty) {
			view.render(buildModel());
			dirty = false;
		}
	}

	public function invalidate():Void dirty = true;

	public function handle(action:ScheduleAction):Void {
		switch (action) {
			case None:
			case SelectTab(next): selectTab(next);
			case SelectGroup(id): setGroup(id);
			case SelectCompareGroup(id): setCompare(id);
			case ShiftDay(delta): nav.shiftDays(delta);
			case ShiftWeek(delta): nav.shiftWeeks(delta);
			case ResetToday: nav.resetToday(); tab = ScheduleTab.Today;
			case ToggleTheme: setTheme(theme.toggle());
			case ToggleReminder: toggleReminder();
			case ToggleImportant(id): toggleImportant(id);
			case EditNote(id): editNote(id);
			case ExpandLesson(id): expandedId = expandedId == id ? "" : id;
			case Search: search();
			case ClearSearch: query = "";
			case Fullscreen: BrowserActions.requestFullscreen();
			case OpenWindow: BrowserActions.openNewWindow((tab : String));
		}
		dirty = true;
	}

	public function cycleGroup():Void {
		setGroup(repo.nextGroup(groupId));
		dirty = true;
	}

	function buildModel():ScheduleScreenModel {
		var m = new ScheduleScreenModel();
		m.tab = tab;
		m.theme = theme;
		m.groups = repo.groups;
		m.groupId = groupId;
		m.groupTitle = repo.groupTitle(groupId);
		m.compareGroupId = compareGroupId;
		m.compareGroupTitle = repo.groupTitle(compareGroupId);
		m.dayTitle = nav.isToday() ? "Сегодня" : nav.dayTitle();
		m.weekLabel = nav.weekLabel();
		m.query = query;
		m.onboarding = onboarding;
		m.remindersEnabled = reminderOn;
		m.todayCards = cards(groupId, nav.selectedDay());
		m.compareCards = cards(compareGroupId, nav.selectedDay());
		m.weekDays = weekDays(groupId);
		m.comments = comments();
		m.message = query == "" ? "" : "Фильтр: " + query;
		return m;
	}

	function cards(gid:String, day:Int):Array<ScheduleCardModel> {
		return [for (l in repo.dayLessons(gid, day, nav.parity(), query)) card(l)];
	}

	function weekDays(gid:String):Array<DayColumnModel> {
		return [for (day in 0...6) new DayColumnModel(WeekCalendar.dayTitle(day), cards(gid, day))];
	}

	function card(l:Lesson):ScheduleCardModel {
		var c = new ScheduleCardModel();
		c.id = l.id;
		c.time = LessonTime.range(l.start, l.end);
		c.title = l.title;
		c.meta = l.teacher + " • " + l.room + " • " + l.parity.label();
		c.kindLabel = l.kind.badge() + " " + l.kind.label();
		c.kindColor = l.kind.color();
		c.note = ScheduleStorage.getString(ScheduleStorage.noteKey(l.id), "");
		c.important = ScheduleStorage.bool(ScheduleStorage.importantKey(l.id), false);
		c.expanded = expandedId == l.id;
		return c;
	}

	function comments():Array<CommentModel> {
		var out:Array<CommentModel> = [];
		for (g in repo.groups) for (l in repo.allLessons(g.id)) {
			var note = ScheduleStorage.getString(ScheduleStorage.noteKey(l.id), "");
			if (note != "") out.push(new CommentModel(l.id, l.title, g.id + " • " + l.teacher + " • " + l.room, note));
		}
		return out;
	}

	function selectTab(next:ScheduleTab):Void {
		tab = next;
		if (tab == ScheduleTab.Today) nav.resetToday();
		ScheduleStorage.setString("tab", (tab : String));
	}

	function setGroup(id:String):Void {
		groupId = repo.safeGroup(id);
		onboarding = false;
		ScheduleStorage.setString("group", groupId);
	}

	function setCompare(id:String):Void {
		compareGroupId = repo.safeGroup(id);
		ScheduleStorage.setString("compareGroup", compareGroupId);
	}

	function setTheme(next:ThemeMode):Void {
		theme = next;
		ScheduleStorage.setString("theme", (theme : String));
	}

	function toggleReminder():Void {
		reminderOn = !reminderOn;
		ScheduleStorage.setBool("reminders", reminderOn);
		if (reminderOn) BrowserActions.requestNotifications();
	}

	function toggleImportant(id:String):Void {
		var key = ScheduleStorage.importantKey(id);
		ScheduleStorage.setBool(key, !ScheduleStorage.bool(key, false));
	}

	function editNote(id:String):Void {
		var key = ScheduleStorage.noteKey(id);
		var next = BrowserActions.prompt("Заметка к паре", ScheduleStorage.getString(key, ""));
		if (next == null) return;
		next = StringTools.trim(next);
		if (next == "") ScheduleStorage.remove(key) else ScheduleStorage.setString(key, next);
	}

	function search():Void {
		var next = BrowserActions.prompt("Поиск по дисциплине, преподавателю или аудитории", query);
		if (next != null) query = StringTools.trim(next);
	}
}
