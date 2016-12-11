package;

import flash.display.InterpolationMethod;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxPath;

import Player;
import Enemy;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	private var _grpEnemies:FlxTypedGroup<Enemy>;

	override public function create():Void
	{

		//_map = new FlxOgmoLoader(AssetPaths.testlvl__oel);
		_map = new FlxOgmoLoader(AssetPaths.easylevel__oel);

		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);

		_player = new Player();

		_grpEnemies = new FlxTypedGroup<Enemy>();
		add(_grpEnemies);

		_map.loadEntities(placeEntities, "entities");
		add(_player);
		FlxG.camera.follow(_player, TOPDOWN, 1);
		super.create();
	}

	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "enemy")
		{
			_grpEnemies.add(new Enemy(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}

	override public function update(elapsed:Float):Void
	{
		movement();
		super.update(elapsed);
		FlxG.collide(_player, _mWalls);
		FlxG.collide(_grpEnemies, _mWalls);
		_grpEnemies.forEach(collideEnemie);

	}

	private function collideEnemie(e:Enemy):Void
	{
		FlxG.collide(e, _mWalls);
	}

	private function movement():Void
	{
		var _leftclick:Bool = false;
		_leftclick = FlxG.mouse.justReleased;

		if (_leftclick)
		{
			var test = FlxG.mouse.getWorldPosition();

			_grpEnemies.forEach(moveEnemie);
		}
	}

	/*
	private function getRoom():Room
	{

	}
	*/

	private function movePlayer():Void
	{

	}

	private function moveEnemie(e:Enemy):Void
	{
		var pathPoints:Array<FlxPoint> = _mWalls.findPath(
			FlxPoint.get(e.x, e.y),
			FlxPoint.get(this._player.x, this._player.y));

		// Tell unit to follow path
		if (pathPoints != null)
			e.path = new FlxPath().start(pathPoints, 50, FlxPath.FORWARD);
	}

}
