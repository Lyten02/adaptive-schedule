package game.input;

/** Logical input actions mapped by InputBindings. */
enum abstract GameAction(Int) to Int {
	var MoveLeft = 0;
	var MoveRight = 1;
	var MoveUp = 2;
	var MoveDown = 3;
	var ToggleDebug = 4;
	var DebugSpeedUp = 5;
	var DebugSpeedDown = 6;
	var DebugResetZoom = 7;
	var TabToday = 8;
	var TabWeek = 9;
	var TabCompare = 10;
	var TabComments = 11;
	var ToggleTheme = 12;
	var Fullscreen = 13;
	var Search = 14;
	var CycleGroup = 15;
	var OpenWindow = 16;
}
