package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxPath;

class Character extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		this.path = new FlxPath();
	}
	
	public function move(path: Array<FlxPoint>): Void {
		this.path.cancel();
		if (path == null) return ;
		this.path.start(path, 150, FlxPath.FORWARD);
		#if debug
			this.path.drawDebug();
		#end
	}
	
	public function isIdle(): Bool {
		return !this.path.active || this.path.finished;
	}
	
}