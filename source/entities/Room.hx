package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

class Room extends FlxSprite
{
	public var _doors: Array<Door> = [];
	private var _exit: Exit = null;

	public var _onClickCallback: Void -> Void;
	public var _isUnlocked: (Bool -> Void) -> Void;
	
	public function new(rect: FlxRect)
	{
		super(rect.x, rect.y);
		this.setSize(rect.width, rect.height);
		makeGraphic(Math.floor(rect.width), Math.floor(rect.height), FlxColor.YELLOW);
		this.alpha = 0;
		FlxMouseEventManager.add(this, onMouseDown, null, onMouseOver, onMouseOut, false, true, false);
	}
	
	public function getRect(): FlxRect {
		return new FlxRect(this.x, this.y, this.width, this.height);
	}
	
	public function getRoomCenter(): FlxPoint {
		return new FlxPoint((this.x*2 + this.width)/2, (this.y*2 + this.height)/2);
	}
	
	private function onMouseDown(sprite:FlxSprite) {
		this._isUnlocked(function(unlocked) {
			if (!unlocked) return ;

			FlxG.sound.play(AssetPaths.door__wav);
			for(d in this._doors)
				d.toggle();
			_onClickCallback();
		});
	}
	
	private function onMouseOver(sprite:FlxSprite) {
		this.alpha = 0.15;
	}
	
	private function onMouseOut(sprite:FlxSprite) {
		this.alpha = 0;
	}
	
	override public function destroy():Void 
	{
		FlxMouseEventManager.remove(this);
		super.destroy();
	}

	public function addDoor(door: Door): Void {
		this._doors.push(door);
		door._rooms.push(this);
	}

	private function getRooms(doors: Array<Door>): Array<Room> {
		var res: Array<Room> = [];
		for(d in doors)
			for (r in d._rooms)
				if (r != this && res.indexOf(r) == -1)
					res.push(r);
		return (res);
	}

	public function getAdjacentRooms(): Array<Room> {
		return this.getRooms(this._doors);
	}

	public function getAdjacentOpenRooms(): Array<Room> {
		return this.getRooms(this._doors.filter(function(door: Door) {
			return door._opened;
		}));
	}
	
	public function isExitRoom(): Bool {
		return (this._exit != null);
	}
	
	public function setExit(exit: Exit): Void {
		this._exit = exit;
		exit._room = this;
		trace("set exit");
	}

}