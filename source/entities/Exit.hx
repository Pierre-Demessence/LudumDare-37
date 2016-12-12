package entities;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Exit extends FlxSprite
{
	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		makeGraphic(Main.TILE_SIZE, Main.TILE_SIZE, FlxColor.GREEN);
	}

}