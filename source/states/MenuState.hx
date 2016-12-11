package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import states.PlayState;

class MenuState extends FlxState
{
	 
	override public function create():Void
	{
		add(new FlxStarField2D(0, 0, 800, 600, 300));
		
		var _txtTitle: FlxText = new FlxText(0, 50, 0, "One Room Game", 40);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(FlxAxes.X);
		add(_txtTitle);
		
		add(new FlxButton(0, 0, "Play", function() {
			FlxG.switchState(new PlayState(Level.LEVELS[0]));
		}).screenCenter());
		
		FlxG.sound.playMusic(AssetPaths.MenuMusic__ogg, 1, true);
		
		super.create();
	}
}