package;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

/**
 * ...
 * @author ...
 */
class Player extends FlxSprite
{
	public var speed:Float = 200;

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		loadGraphic(AssetPaths.voleur__png, true, 32, 32);

		// retourne le sprite quand le player va vers la droite
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		animation.add("lr", [10, 11, 10, 13], 6, false);
		animation.add("u", [15, 16, 15, 17], 6, false);
		animation.add("d", [0, 1, 0, 3], 6, false);

		// ralentissement progressif
		drag.x = drag.y = 1600;

		setSize(25, 30);
		offset.set(2, 0);

	}

	override public function update(elapsed:Float):Void
	{
		movement();
		super.update(elapsed);
	}

	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;

		_up = FlxG.keys.anyPressed([UP, W]);
		_down = FlxG.keys.anyPressed([DOWN, S]);
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);

		// anulation directions opposées
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;

		if (_up || _down || _left || _right)
		{
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
				facing = FlxObject.UP;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				facing = FlxObject.DOWN;
			}
			else if (_left)
			{
				mA = 180;
				facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				mA = 0;
				facing = FlxObject.RIGHT;
			}

			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), mA);

			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) // if the player is moving (velocity is not 0 for either axis), we need to change the animation to match their facing
			{
				switch (facing)
				{
					case FlxObject.LEFT, FlxObject.RIGHT:
						animation.play("lr");
					case FlxObject.UP:
						animation.play("u");
					case FlxObject.DOWN:
						animation.play("d");
				}
			}

		}
	}

}