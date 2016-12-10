package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	private var _btnPlay: FlxButton;
	 
	override public function create():Void
	{
		this._btnPlay = new FlxButton(0, 0, "Play", this.clickPlay);
		_btnPlay.screenCenter();
		add(_btnPlay);
		
		FlxG.sound.playMusic(AssetPaths.MenuMusic__ogg, 1, true);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
}