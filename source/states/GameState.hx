package states;

import flixel.*;
import flixel.util.*;

import object.ui.Transition;

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
	}
}
