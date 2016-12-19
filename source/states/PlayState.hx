package states;

import entities.Character;
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
import flixel.util.FlxPath;
import states.GameOverState;
import states.WinState;
import flixel.math.FlxMath;

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
	private var _nbMove: Int = 0;

	override function new(level: Level)
	{
		super();
		this._level = level;
	}

	override public function create():Void
	{
		var levelName: String = this._level != null ? this._level._name : "level_01";

		_map = new FlxOgmoLoader('assets/data/$levelName.oel');

		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, Main.TILE_SIZE, Main.TILE_SIZE, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);

		add(_mWalls);
		add(_grpRooms = new FlxTypedGroup<Room>());
		add(_grpDoors = new FlxTypedGroup<Door>());
		add(_grpEnemies = new FlxTypedGroup<Enemy>());
		_map.loadRectangles(function(rect: FlxRect)
		{
			var room: Room;
			_grpRooms.add(room = new Room(rect));
			room._onClickCallback = this.onRoomClicked;
			room._isUnlocked = function(cb : Bool -> Void)
			{
				cb(this.canMove());
			}
		}, "rooms");
		_map.loadEntities(placeEntities, "entities");
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
			var e: Enemy;
			_grpEnemies.add(e = new Enemy(x, y, Std.parseInt(entityData.get("etype"))));
		}
		else if (entityName == "door")
		{
			var door: Door = new Door(x, y, entityData.get("open") == "True");
			_grpDoors.add(door);
			this._grpRooms.forEach(function(room: Room)
			{
				var roomRect: FlxRect = room.getRect();
				var doorRect: FlxRect = new FlxRect(x - 1, y - 1, Main.TILE_SIZE*1.5, Main.TILE_SIZE*1.5);
				if (roomRect.overlaps(doorRect))
					room.addDoor(door);
			});
		}
		else if (entityName == "exit")
		{
			add(_exit = new Exit());
			_exit.x = x;
			_exit.y = y;

			this._grpRooms.forEach(function(room: Room)
			{
				var roomRect: FlxRect = room.getRect();
				var exitRect: FlxRect = new FlxRect(x - 1, y - 1, Main.TILE_SIZE*1.5, Main.TILE_SIZE*1.5);
				if (roomRect.overlaps(exitRect))
					room.setExit(_exit);
			});

		}
	}

	private function getRoom(pos: FlxPoint): Room
	{
		for (room in this._grpRooms.members)
			if (room.getRect().containsPoint(pos))
				return room;
		return null;
	}

	private function canMove(): Bool
	{
		for (c in getCharacters())
			if (!c.isIdle())
				return false;
		return true;
	}

	private function getCharacters(): Array<Character>
	{
		var res: Array<Character> = new Array<Character>();
		this._grpEnemies.forEach(function(e: Enemy)
		{
			res.push(e);
		});
		res.push(this._player);
		return res;
	}

	private function onRoomClicked()
	{
		_grpDoors.forEach(function(d: Door)
		{
			_mWalls.setTile(Math.floor(d.x / Main.TILE_SIZE), Math.floor(d.y / Main.TILE_SIZE), d._opened ? 1 : 2, true);
		});

		_player.move(this.findPath(_player, _exit));
		/*
				_grpEnemies.forEach(function(e: Enemy) {
					e.move(this.findPath(e, _player));
				});
		*/

		_player.path.onComplete = function(path: FlxPath): Void
		{

			var playerRoom: Room = this.getRoom(_player.getPosition());
			if (playerRoom.isExitRoom())
			{
				trace("isExitRoom == " + playerRoom.isExitRoom());
				FlxG.sound.play(AssetPaths.win__wav).persist = true;
				FlxG.switchState(new WinState(this._level));
			}
			
			_grpEnemies.forEach(function(e: Enemy)
			{
				e.move(this.findPath(e, _player));
			});
			
		}
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(_player, _grpEnemies, function(a, b)
		{
			FlxG.sound.play(AssetPaths.lose__wav).persist = true;
			FlxG.switchState(new GameOverState(this._level));
		});
		FlxG.collide(_player, _exit, function(a, b)
		{
			FlxG.sound.play(AssetPaths.win__wav).persist = true;
			FlxG.switchState(new WinState(this._level));
		});

		super.update(elapsed);
	}

	private function findPath(from: FlxSprite, to: FlxSprite): Array<FlxPoint>
	{
		var path: Array<FlxPoint> = _mWalls.findPath(from.getPosition(), to.getPosition(), true, false, FlxTilemapDiagonalPolicy.NONE);
		if (path == null) return null;

		var fromRoom: Room = this.getRoom(from.getPosition());
		var room: Room = null;
		for (pos in path)
			if ((room = this.getRoom(pos)) != fromRoom)
				break;
		if (room == null) return null;

		path = _mWalls.findPath(from.getPosition(), room.getRoomCenter(), true, false, FlxTilemapDiagonalPolicy.NONE);

		if (path != null) path = path.slice(1);
		return path;
	}

}
