package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIList;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;

class LevelSelectState extends FlxState
{	
	override public function create():Void
	{
		add(new FlxStarField2D(0, 0, 1280, 960, 300));
		
		var txtTitle: FlxText = new FlxText(0, 300, 0, "Level Selection", 40);
		txtTitle.alignment = CENTER;
		txtTitle.screenCenter(FlxAxes.X);
		add(txtTitle);
		
		var levelList: FlxUIList = new FlxUIList();
		levelList.set_spacing(new FlxButton().height * 2);
		var subLevelList: FlxUIList = new FlxUIList();
		for (i in (0...Level.LEVELS.length)) {
			if (i % 4 == 0) {
				levelList.add(subLevelList = new FlxUIList());
				subLevelList.set_spacing(10);
				subLevelList.set_stacking(FlxUIList.STACK_HORIZONTAL);
			}	
			
			var l: Level = Level.LEVELS[i];
			var levelName: String = "Level " + l._name.split('_')[1];
			subLevelList.add(new FlxButton(0, 0, levelName, function() {
				FlxG.switchState(new PlayState(l));
			}));
		}
		levelList.set_stacking(FlxUIList.STACK_VERTICAL);
		levelList.screenCenter();
		levelList.x -= new FlxButton().width * 4 / 2;
		levelList.y -= 100;
		add(levelList);
		
		var backButton: FlxButton = new FlxButton(0, 0, "Back", function() {
			FlxG.switchState(new MenuState());
		});
		backButton.screenCenter();
		backButton.y += 150;
		add(backButton);
		
		FlxG.camera.zoom = 2;

		super.create();
	}
}