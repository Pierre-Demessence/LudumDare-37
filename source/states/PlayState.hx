package states;

import entities.Door;
import entities.Enemy;
import entities.Exit;
import entities.Player;
import entities.Room;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tile.FlxBaseTilemap.FlxTilemapDiagonalPolicy;
import flixel.tile.FlxTilemap;
import states.GameOverState;
import states.WinState;

class PlayState extends FlxState
{
	private var _level: Level;
	private var _player: Player;
	private var _exit: Exit;
	private var _map: FlxOgmoLoader;
	private var _mWalls: FlxTilemap;
	private var _grpEnemies: FlxTypedGroup<Enemy>;
	private var _grpDoors: FlxTypedGroup<Door>;
	private var _grpRooms: FlxTypedGroup<Room>;

	override function new(level: Level) {
		super();
		this._level = level;
	}
	
	override public function create():Void
	{
		var levelName: String = this._level._name;
		
		_map = new FlxOgmoLoader('assets/data/$levelName.oel');

		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 32, 32, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		
		add(_mWalls);
		add(_grpEnemies = new FlxTypedGroup<Enemy>());
		add(_grpDoors = new FlxTypedGroup<Door>());
		add(_grpRooms = new FlxTypedGroup<Room>());
		_map.loadEntities(placeEntities, "entities");
		/*
		_map.loadRectangles(function(rect: FlxRect) {
			_grpRooms.add(new Room(rect));
		}, "rooms");
		*/
		_grpRooms.add(new Room(new FlxRect(20, 20, 50, 50)));
		
		FlxG.camera.follow(_player, TOPDOWN, 1);
		
		super.create();
	}

	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			add(_player = new Player());
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
			add(_exit = new Exit());
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
		
		FlxG.collide(_player, _grpEnemies, function(a, b) {
			FlxG.switchState(new GameOverState(this._level));
		});
		FlxG.collide(_player, _exit, function(a, b) {
			FlxG.switchState(new WinState(this._level));
		});
		
		if (FlxG.mouse.justReleased && this.turnEnded()) {
			getRoom(FlxG.mouse.getWorldPosition());
			
			_grpDoors.forEach(function(d: Door) {
				_mWalls.setTile(Math.floor(d.x / 32), Math.floor(d.y / 32), d._opened ? 1 : 2, true);
			});
			
			_grpEnemies.forEach(function(e: Enemy) {
				e.move(this.findPath(e, _player));
			});
			_player.move(this.findPath(_player, _exit));
		}
		
	}
	
	private function getRoom(mousePos: FlxPoint):Void
	{
		_grpDoors.forEach(function(d: Door) {
			if (d.getHitbox().containsPoint(mousePos))
				d.toggle();
		});
	}
	
	private function findPath(from: FlxSprite, to: FlxSprite): Array<FlxPoint> {
		var path: Array<FlxPoint> = _mWalls.findPath(from.getPosition(), to.getPosition(), false, false, FlxTilemapDiagonalPolicy.NONE);
		if (path != null) path = path.slice(1);
		return path;
	}
	
	private function turnEnded(): Bool {
		var res: Bool = true;
		_grpEnemies.forEach(function(e : Enemy) {
			res = res && e.hasMoved();
		});
		return res;
	}

}
