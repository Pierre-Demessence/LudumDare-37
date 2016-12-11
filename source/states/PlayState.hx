package states;

import flash.display.InterpolationMethod;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
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

import entities.Player;
import entities.Enemy;
import entities.Door;

class PlayState extends FlxState
{
	private var _player:entities.Player;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	private var _grpEnemies:FlxTypedGroup<entities.Enemy>;
	private var _grpDoors:FlxTypedGroup<entities.Door>;

	override public function create():Void
	{

		//_map = new FlxOgmoLoader(AssetPaths.testlvl__oel);
		_map = new FlxOgmoLoader(AssetPaths.easylevel__oel);

		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		
		add(_mWalls);

		_player = new entities.Player();

		_grpEnemies = new FlxTypedGroup<entities.Enemy>();
		add(_grpEnemies);
		
		_grpDoors = new FlxTypedGroup<entities.Door>();
		add(_grpDoors);

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
			_grpEnemies.add(new Enemy(x, y, Std.parseInt(entityData.get("etype"))));
		}
		else if (entityName == "door")
		{
			_grpDoors.add(new Door(x, y, new FlxRandom().bool()));
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_player, _mWalls);
		FlxG.collide(_grpEnemies, _mWalls);
		_grpDoors.forEach(function (d: Door) {
			if (!d._opened) FlxG.collide(d, _grpEnemies);
		});
		
		movement();
	}


	private function movement():Void
	{
		var _leftclick:Bool = false;
		_leftclick = FlxG.mouse.justReleased;

		if (_leftclick)
		{
			var test = FlxG.mouse.getWorldPosition();
			this.getRoom(test);
			_grpEnemies.forEach(moveEnemie);
		}
	}

	
	private function getRoom(mousePos: FlxPoint):Void
	{
		FlxG.log.add("My var: " + mousePos);
	}

	private function movePlayer():Void
	{

	}

	private function moveEnemie(e:entities.Enemy):Void
	{
		var pathPoints:Array<FlxPoint> = _mWalls.findPath(
			FlxPoint.get(e.x, e.y),
			FlxPoint.get(this._player.x, this._player.y));

		// Tell unit to follow path
		if (pathPoints != null)
			e.path = new FlxPath().start(pathPoints, 50, FlxPath.FORWARD);
	}

}
