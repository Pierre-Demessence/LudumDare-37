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
import entities.Exit;
import entities.Door;

class PlayState extends FlxState
{
	private var _player:entities.Player;
	private var _exit:entities.Exit;
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

		_grpEnemies = new FlxTypedGroup<entities.Enemy>();
		add(_grpEnemies);
		
		_grpDoors = new FlxTypedGroup<entities.Door>();
		add(_grpDoors);

		_exit = new entities.Exit();
		add(_exit);

		_player = new entities.Player();
		
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
			_grpDoors.add(new Door(x, y, entityData.get("open") == "True"));
		}
		else if (entityName == "exit")
		{
			_exit.x = x;
			_exit.y = y;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		/*
		FlxG.collide(_player, _mWalls);
		FlxG.collide(_grpEnemies, _mWalls);
		_grpDoors.forEach(function (d: Door) {
			if (!d._opened) FlxG.collide(d, _grpEnemies);
		});
		*/
		_grpDoors.forEach(function (d: Door) {
			_mWalls.setTile(Math.floor(d.x / 16), Math.floor(d.y / 16), d._opened ? 1 : 2, true);
		});
		
		if (FlxG.mouse.justReleased && this.turnEnded()) {
			getRoom(FlxG.mouse.getWorldPosition());
			_grpEnemies.forEach(moveEnemie);
		}
		
	}
	
	private function getRoom(mousePos: FlxPoint):Void
	{
		_grpDoors.forEach(function(d: Door) {
			if (d.getHitbox().containsPoint(mousePos))
				d.toggle();
		});
	}

	private function moveEnemie(e: Enemy):Void
	{
		var pathPoints:Array<FlxPoint> = _mWalls.findPath(
			FlxPoint.get(e.x, e.y),
			FlxPoint.get(this._player.x, this._player.y));

		// Tell unit to follow path
		if (pathPoints != null)
			e.path = new FlxPath().start(pathPoints, 150, FlxPath.FORWARD);
	}
	
	private function turnEnded(): Bool {
		var res: Bool = true;
		_grpEnemies.forEach(function(e : Enemy) {
			res = res && (e.path == null || e.path.finished);
		});
		return res;
	}

}
