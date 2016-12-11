package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import states.PlayState;

class GameOverState extends FlxState
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
		
		var _txtTitle: FlxText = new FlxText(0, 50, 0, "Game\nOver", 40);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(FlxAxes.X);
		add(_txtTitle);
		
		var _btnWin: FlxButton = new FlxButton(0, 200, "Replay Level", function() {
			FlxG.switchState(new PlayState(this._level));
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
				
		super.create();
	}
}