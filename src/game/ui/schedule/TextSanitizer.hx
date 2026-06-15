package game.ui.schedule;

import h2d.Font;

class TextSanitizer {
	public static function clean(text:String, font:Font):String {
		if (text == null || text == "") return "";
		var out = new StringBuf();
		var i = 0;
		while (i < text.length) {
			var code = StringTools.fastCodeAt(text, i);
			if (isHighSurrogate(code)) {
				i += i + 1 < text.length && isLowSurrogate(StringTools.fastCodeAt(text, i + 1)) ? 2 : 1;
				continue;
			}
			if (isLowSurrogate(code)) {
				i++;
				continue;
			}
			var replacement = replacementFor(code);
			if (replacement != null) out.add(replacement);
			else if (isAllowedControl(code) || font.hasChar(code)) out.addChar(code);
			i++;
		}
		return out.toString();
	}

	static function replacementFor(code:Int):Null<String> {
		return switch (code) {
			case 0x2010, 0x2011, 0x2012, 0x2013, 0x2014, 0x2015: "-";
			case 0x2022: "-";
			case 0x2026: "...";
			case 0x2039, 0x2190: "<";
			case 0x203A, 0x2192: ">";
			case 0x2191: "^";
			case 0x2193: "v";
			case 0x2194: "<->";
			case 0x2605, 0x2606, 0x270E: "";
			default: null;
		}
	}

	static inline function isAllowedControl(code:Int):Bool {
		return code == "
".code || code == "".code || code == "	".code;
	}

	static inline function isHighSurrogate(code:Int):Bool {
		return code >= 0xD800 && code <= 0xDBFF;
	}

	static inline function isLowSurrogate(code:Int):Bool {
		return code >= 0xDC00 && code <= 0xDFFF;
	}
}
