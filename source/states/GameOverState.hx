package states;

import states.PlayState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxAxes;

class GameOverState extends FlxState
{
	private var _btnPlay: FlxButton;
	private var _txtTitle:FlxText;

	override public function create():Void
	{
		add(new FlxStarField2D(0, 0, 800, 600, 300));
		
		_txtTitle = new FlxText(0, 50, 0, "Game\nOver", 40);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(FlxAxes.X);
		add(_txtTitle);

		
		
		this._btnPlay = new FlxButton(0, 0, "Replay", this.clickReplay);
		_btnPlay.screenCenter();
		add(_btnPlay);
		
		FlxG.sound.playMusic(AssetPaths.MenuMusic__ogg, 1, true);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickReplay():Void
	{
		FlxG.switchState(new states.PlayState());
	}
}