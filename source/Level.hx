package;

class Level 
{
	public static var LEVELS: Array<Level> = [
		new Level('level_01'),
		new Level('level_02')
	];
	
	public static function getNextLevel(level: Level) {
		return LEVELS[LEVELS.indexOf(level)+1];
	}

	public var _name: String;
	public function new(name: String) 
	{
		this._name = name;
	}
	
}