package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import states.PlayState;

class WinState extends FlxState
{
	private var _level: Level;
	
	public function new(level: Level)
	{
		super();
		this._level = level;
	}
	
	override public function create():Void
	{
		add(new FlxStarField2D(0, 0, 800, 600, 300));
		
		if (Level.getNextLevel(this._level) != null)
			this.winLevel();
		else
			this.winGame();
		
		super.create();
	}
	
	private function winLevel(): Void {
		var _txtTitle: FlxText = new FlxText(0, 50, 0, "WOW\nYou're so PRO :o", 40);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(FlxAxes.X);
		add(_txtTitle);

		var _btnWin: FlxButton = new FlxButton(0, 200, "Next level", function() {
			FlxG.switchState(new PlayState(Level.getNextLevel(this._level)));
		});
		_btnWin.x = FlxG.width / 2 - _btnWin.width - 10;
		_btnWin.y = FlxG.height / 2 - _btnWin.height - 10;
		add(_btnWin);

		
		var _btnGameOver: FlxButton = new FlxButton(0, 0, "Menu", function() {
			FlxG.switchState(new MenuState());
		});
		_btnGameOver.x = FlxG.width / 2 + 10;
		_btnGameOver.y = FlxG.height / 2 - _btnGameOver.height - 10;
		add(_btnGameOver);
	}
	
	private function winGame(): Void {
		var _txtTitle: FlxText = new FlxText(0, 50, 0, "You WON the Game !!", 40);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(FlxAxes.X);
		add(_txtTitle);
		
		add(new FlxButton(0, 0, "Menu", function() {
			FlxG.switchState(new MenuState());
		}).screenCenter());
	}
}