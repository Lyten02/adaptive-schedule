package game;

import starter.IGame;
import game.input.InputBindings;
import game.states.IGameState;
import game.states.ScheduleState;
import loc.base.LocaleId;
import loc.text.I18n;
import loc.text.config.ConfigManager;

/** Root container for the smart schedule application. */
class Game implements IGame {
	public var app(default, null):hxd.App;
	public var input(default, null):InputBindings;
	public var style(default, null):h2d.domkit.Style;

	var currentState:IGameState;

	public function new() {}

	public function init(app:hxd.App):Void {
		var cfg = ConfigManager.load();
		I18n.init(LocaleId.EN);
		var requested = LocaleId.parse(cfg.language);
		if ((requested : String) != (LocaleId.EN : String)) I18n.setLanguage(requested);

		this.app = app;
		this.input = new InputBindings();
		app.s2d.scaleMode = Resize;
		style = new h2d.domkit.Style();
		style.load(hxd.Res.ui.style);
		switchState(new ScheduleState(this));
	}

	public function update(dt:Float):Void {
		input.update(dt);
		if (style != null) style.sync(dt);
		if (currentState != null) currentState.update(dt);
	}

	public function dispose():Void {
		if (currentState != null) { currentState.exit(); currentState = null; }
		if (input != null) { input.dispose(); input = null; }
	}

	public function switchState(next:IGameState):Void {
		if (currentState != null) currentState.exit();
		currentState = next;
		currentState.enter();
	}
}
