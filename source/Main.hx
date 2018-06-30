package;

import flixel.*;
import flixel.FlxG;
import openfl.display.Sprite;

import states.*;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, StartState, 1, 60, 60, true, false));
		FlxG.mouse.useSystemCursor = true;
		FlxG.autoPause = false;
	}
}
