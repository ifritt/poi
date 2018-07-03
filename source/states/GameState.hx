package states;

import flixel.*;
import flixel.util.*;

import object.ui.Dialog;

class GameState extends PoiState
{
	override public function create():Void
	{
		add(new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE));

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.SPACE)
		{
			var line:Line = new Line("doggie", "`shake`this should shake. `none`this shouldn't.");
			var anotherLine:Line = new Line("another doggie", "I'm gonna say something.. and pause.\\ That was a test to see if it paused.");
			dialogEngine.speak([
				line,
				anotherLine
			]);
		}
	}
}
