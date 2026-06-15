package game.states;

import game.Game;
import game.input.GameAction;
import game.schedule.ScheduleRepository;
import game.ui.schedule.ScheduleAction;
import game.ui.schedule.SchedulePresenter;
import game.ui.schedule.ScheduleTab;
import game.ui.schedule.ScheduleView;

class ScheduleState implements IGameState {
	static inline var DATA_PATH:String = "schedule/groups.json";
	static inline var SWIPE:Float = 70;

	var game:Game;
	var root:h2d.Object;
	var view:ScheduleView;
	var presenter:SchedulePresenter;
	var downX:Float = 0;
	var downY:Float = 0;
	var swiped:Bool = false;

	public function new(game:Game) {
		this.game = game;
	}

	public function enter():Void {
		root = new h2d.Object(game.app.s2d);
		var repo = ScheduleRepository.parse(hxd.Res.load(DATA_PATH).toText());
		view = new ScheduleView(root);
		presenter = new SchedulePresenter(view, repo);
		bindPointer();
	}

	public function update(dt:Float):Void {
		if (view.resize(game.app.s2d.width, game.app.s2d.height)) presenter.invalidate();
		handleKeyboard();
		presenter.update(dt);
	}

	public function exit():Void {
		if (view != null) { view.dispose(); view = null; }
		if (root != null) { root.remove(); root = null; }
	}

	function bindPointer():Void {
		view.interactive.onPush = function(e:hxd.Event) {
			downX = e.relX;
			downY = e.relY;
			swiped = false;
		};
		view.interactive.onRelease = function(e:hxd.Event) {
			var dx = e.relX - downX;
			var dy = e.relY - downY;
			if (Math.abs(dx) > SWIPE && Math.abs(dx) > Math.abs(dy)) {
				presenter.handle(ScheduleAction.ShiftDay(dx < 0 ? 1 : -1));
				swiped = true;
				view.interactive.preventClick();
			} else if (Math.abs(dy) > SWIPE && Math.abs(dy) > Math.abs(dx)) {
				presenter.handle(ScheduleAction.ShiftWeek(dy < 0 ? 1 : -1));
				swiped = true;
				view.interactive.preventClick();
			}
		};
		view.interactive.onClick = function(e:hxd.Event) {
			if (!swiped) presenter.handle(view.actionAt(e.relX, e.relY));
		};
	}

	function handleKeyboard():Void {
		if (game.input.wasPressed(GameAction.MoveLeft)) presenter.handle(ScheduleAction.ShiftDay(-1));
		if (game.input.wasPressed(GameAction.MoveRight)) presenter.handle(ScheduleAction.ShiftDay(1));
		if (game.input.wasPressed(GameAction.MoveUp)) presenter.handle(ScheduleAction.ShiftWeek(-1));
		if (game.input.wasPressed(GameAction.MoveDown)) presenter.handle(ScheduleAction.ShiftWeek(1));
		if (game.input.wasPressed(GameAction.TabToday)) presenter.handle(ScheduleAction.SelectTab(ScheduleTab.Today));
		if (game.input.wasPressed(GameAction.TabWeek)) presenter.handle(ScheduleAction.SelectTab(ScheduleTab.Week));
		if (game.input.wasPressed(GameAction.TabCompare)) presenter.handle(ScheduleAction.SelectTab(ScheduleTab.Compare));
		if (game.input.wasPressed(GameAction.TabComments)) presenter.handle(ScheduleAction.SelectTab(ScheduleTab.Comments));
		if (game.input.wasPressed(GameAction.ToggleTheme)) presenter.handle(ScheduleAction.ToggleTheme);
		if (game.input.wasPressed(GameAction.Fullscreen)) presenter.handle(ScheduleAction.Fullscreen);
		if (game.input.wasPressed(GameAction.Search)) presenter.handle(ScheduleAction.Search);
		if (game.input.wasPressed(GameAction.CycleGroup)) presenter.cycleGroup();
		if (game.input.wasPressed(GameAction.OpenWindow)) presenter.handle(ScheduleAction.OpenWindow);
	}
}
