package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import states.CreditsState;
import states.LevelSelectState;
import states.PlayState;

class MenuState extends FlxState
{
	 
	override public function create():Void
	{
		add(new FlxStarField2D(0, 0, 1280, 960, 300));
		
		var txtTitle: FlxText = new FlxText(0, 250, 0, "One Room Game", 40);
		txtTitle.alignment = CENTER;
		txtTitle.screenCenter(FlxAxes.X);
		add(txtTitle);
		
		var playButton: FlxButton = new FlxButton(0, 0, "Play", function() {
			FlxG.switchState(new PlayState(Level.LEVELS[0]));
		});
		playButton.screenCenter();
		playButton.y -= 30;
		add(playButton);
		
		var selectButton: FlxButton = new FlxButton(0, 0, "Select Level", function() {
			FlxG.switchState(new LevelSelectState());
		});
		selectButton.screenCenter();
		add(selectButton);
		
		var creditsButton: FlxButton = new FlxButton(0, 0, "Credits", function() {
			FlxG.switchState(new CreditsState());
		});
		creditsButton.screenCenter();
		creditsButton.y += 30;
		add(creditsButton);
		
		if (FlxG.sound.music == null)
			FlxG.sound.playMusic(AssetPaths.MenuMusic__ogg, 1, true);
				
			
		FlxG.camera.zoom = 2;

		super.create();
	}
}