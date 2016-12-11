package states;

import states.PlayState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxAxes;

class WinLvlState extends FlxState
{
	private var _btnWin: FlxButton;
	private var _btnGameOver: FlxButton;

	private var _txtTitle:FlxText;

	override public function create():Void
	{
		add(new FlxStarField2D(0, 0, 800, 600, 300));
		
		_txtTitle = new FlxText(0, 50, 0, "WOW\nYou're so PRO :o", 40);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(FlxAxes.X);
		add(_txtTitle);

		this._btnWin = new FlxButton(0, 200, "Next level", this.clickNextLevel);
		//_btnWin.screenCenter();
		_btnWin.x = (FlxG.width / 2) - _btnWin.width - 10;
		_btnWin.y = FlxG.height / 2 - _btnWin.height - 10;

		add(_btnWin);

		
		this._btnGameOver = new FlxButton(0, 0, "Replay", this.clickReplay);
		//_btnGameOver.screenCenter();
		_btnGameOver.x = (FlxG.width / 2) + 10;
		_btnGameOver.y = FlxG.height / 2 - _btnGameOver.height - 10;

		add(_btnGameOver);
		
		FlxG.sound.playMusic(AssetPaths.MenuMusic__ogg, 1, true);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickNextLevel():Void
	{
		//FlxG.switchState(new states.PlayState());
	}
	
	private function clickReplay():Void
	{
		FlxG.switchState(new states.PlayState());
	}
}