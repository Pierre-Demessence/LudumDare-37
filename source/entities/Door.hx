package entities;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Door extends FlxSprite
{
	public var _opened: Bool = false;

	public function new(?X:Float=0, ?Y:Float=0, opened:Bool)
	{
		super(X, Y);
		this._opened = opened;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		makeGraphic(16, 16, this._opened ? FlxColor.CYAN : FlxColor.BLUE);
	}

}