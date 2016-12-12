package entities;

import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

class Room extends FlxSprite
{
	public var _doors: Array<Door> = [];
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
	
	private function onMouseDown(sprite:FlxSprite) {
		this._isUnlocked(function(unlocked) {
			if (!unlocked) return ;
			for(d in this._doors)
				d.toggle();
			_onClickCallback();
		});
	}
	
	private function onMouseOver(sprite:FlxSprite) {
		this.alpha = 0.25;
	}
	
	private function onMouseOut(sprite:FlxSprite) {
		this.alpha = 0;
	}
	
	override public function destroy():Void 
	{
		FlxMouseEventManager.remove(this);
		super.destroy();
	}
	
}