package states;

import flixel.*;
import flixel.util.*;
import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;

import object.ui.*;

class StartState extends PoiState
{
	// public var hudElements:List<HUD>

	override public function create():Void
	{
		FlxG.plugins.add(new FlxMouseEventManager());

		add(new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE));

		var menu:Menu = new Menu(this);
		menu.makeMainMenu();
		add(menu);

		// init classes and functions before supercall
		super.create();
		// functions based off inited classes, after supercall

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}