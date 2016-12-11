package entities;

import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

class Room extends FlxSprite
{
	public function new(rect: FlxRect)
	{
		super(rect.x, rect.y);
		this.setSize(rect.width, rect.height);
		makeGraphic(Math.floor(rect.width), Math.floor(rect.height), FlxColor.fromRGB(255, 255, 0, 100));
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function hover() {
		trace("Room Hover");
	}
	
	public function click() {
		trace("Room Clicked");
	}
		
	
}