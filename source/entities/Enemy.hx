package entities;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxPath;

class Enemy extends Character
{
	public var speed:Float = 200;
	public var etype(default, null):Int;

	public function new(?X:Float=0, ?Y:Float=0, EType:Int)
	{
		super(X, Y);
		etype = EType;
		//makeGraphic(Main.TILE_SIZE, Main.TILE_SIZE, FlxColor.RED);

		loadGraphic(AssetPaths.cop__png, true, 32, 32);

		// retourne le sprite quand le player va vers la droite

		/*
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		animation.add("lr", [0, 1], 6, false);
		animation.add("u", [8, 9, 8, 10], 6, false);
		animation.add("d", [4, 5, 4, 6], 6, false);
		*/
		// ralentissement progressif
		drag.x = drag.y = 1600;

		/*
		setSize(15, 30);
		offset.set(5, 0);
		*/
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

}