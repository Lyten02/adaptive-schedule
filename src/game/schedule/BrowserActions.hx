package game.schedule;

class BrowserActions {
	public static function hashTab():String {
		#if (js && !nodejs)
		var h = js.Browser.window.location.hash;
		return h != null && h.length > 1 ? h.substr(1) : "";
		#else
		return "";
		#end
	}

	public static function prompt(title:String, value:String):Null<String> {
		#if (js && !nodejs)
		return js.Browser.window.prompt(title, value);
		#else
		return null;
		#end
	}

	public static function requestFullscreen():Void {
		#if (js && !nodejs)
		var doc:Dynamic = js.Browser.document;
		var el:Dynamic = doc.documentElement;
		if (doc.fullscreenElement != null) untyped doc.exitFullscreen();
		else if (el.requestFullscreen != null) untyped el.requestFullscreen();
		#end
	}

	public static function openNewWindow(tab:String):Void {
		#if (js && !nodejs)
		var base = js.Browser.window.location.href.split("#")[0];
		js.Browser.window.open(base + "#" + tab, "_blank");
		#end
	}

	public static function requestNotifications():Void {
		#if (js && !nodejs)
		var n:Dynamic = js.Syntax.code("window.Notification");
		if (n != null && n.permission == "default") n.requestPermission();
		#end
	}

	public static function notify(title:String, body:String):Void {
		#if (js && !nodejs)
		var n:Dynamic = js.Syntax.code("window.Notification");
		if (n != null && n.permission == "granted") js.Syntax.code("new Notification({0}, { body: {1} })", title, body);
		#end
	}
}
