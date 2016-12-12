package;

import flixel.FlxGame;
import openfl.display.Sprite;

import states.MenuState;

class Main extends Sprite
{
	public static var TILE_SIZE: Int = 32;
	
	public function new()
	{
		super();
		//addChild(new FlxGame(640, 480, MenuState));
		addChild(new FlxGame(1280, 960, MenuState));
	}
}