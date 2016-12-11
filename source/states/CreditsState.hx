package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxStarField.FlxStarField2D;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;

class CreditsState extends FlxState
{	
	override public function create():Void
	{
		add(new FlxStarField2D(0, 0, 800, 600, 300));
		
		var txtTitle: FlxText = new FlxText(0, 50, 0, "Credits", 40);
		txtTitle.alignment = CENTER;
		txtTitle.screenCenter(FlxAxes.X);
		add(txtTitle);
		
		var txt1: FlxText = new FlxText(0, 0, 0, "Game by\nAdrien Rouchy\nand\nPierre Demessence", 30);
		txt1.alignment = CENTER;
		txt1.screenCenter();
		txt1.y -= 25;
		add(txt1);
		
		var txt2: FlxText = new FlxText(0, 0, 0, "Made with HaxeFlixel", 30);
		txt2.alignment = CENTER;
		txt2.screenCenter();
		txt2.y += 100;
		add(txt2);
		
		var backButton: FlxButton = new FlxButton(0, 0, "Back", function() {
			FlxG.switchState(new MenuState());
		});
		backButton.screenCenter();
		backButton.y += 150;
		add(backButton);
		
		super.create();
	}
}