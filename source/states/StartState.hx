package states;

import flixel.*;
import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;

import object.ui.*;

class StartState extends FlxState
{
	// public var hudElements:List<HUD>

	override public function create():Void
	{
		super.create();
		FlxG.plugins.add(new FlxMouseEventManager());

		var menu:Menu = new Menu();
		menu.makeMainMenu();
		add(menu);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}