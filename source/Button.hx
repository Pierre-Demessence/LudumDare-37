package;

import flixel.FlxG;
import flixel.ui.FlxButton;

class Button extends FlxButton
{
		private var _onClick: Void->Void;

		override function new(x: Float = 0, y: Float = 0, ?text: String, ?onClick: Void->Void) {
			this._onClick = onClick;
			super(x, y, text, this.onClickFn);
		}

		private function onClickFn(): Void {
			FlxG.sound.play(AssetPaths.beep__wav).persist = true;

			if (this._onClick != null)
				this._onClick();
		}
}