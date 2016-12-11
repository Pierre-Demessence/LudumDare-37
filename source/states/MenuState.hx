package states;

import states.PlayState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	private var _btnPlay: FlxButton;
	 
	override public function create():Void
	{
		add(new FlxStarField2D(0, 0, 800, 600, 300));
		
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
		FlxG.switchState(new states.PlayState());
	}
}