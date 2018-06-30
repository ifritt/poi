package object.ui;

import flash.system.System;

import flixel.*;
import flixel.text.*;
import flixel.group.FlxGroup;
import flixel.tweens.*;
import flixel.input.mouse.FlxMouseEventManager;

/**
 *  Menu Class
 */
class Menu extends FlxGroup
{
	private var state:FlxState;

	public function new()
	{
		super(100);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function makeMainMenu():Void
	{
		// initialize in backwards order.
		var mainMenu:ButtonGroup = new ButtonGroup();
		var startMenu:ButtonGroup = new ButtonGroup();

		/* New Game submenu */

		/* Load submenu */

		/* Start submenu */
		var newGameButton:NewGameButton = new NewGameButton(200, 400);
		var startPreviousButton:PreviousMenuButton = new PreviousMenuButton(200, 460, startMenu, mainMenu);
		startMenu.add(newGameButton);
		startMenu.add(startPreviousButton);
		startMenu.init(false);

		add(startMenu);

		/* Main Menu */
		var startButton = new StartButton(100, 400, mainMenu, startMenu);
		var quitButton = new QuitButton(100, 430);
		mainMenu.add(startButton);
		mainMenu.add(quitButton);
		mainMenu.init(true);

		add(mainMenu);
	}
}

/**
 *  ButtonGroup class
 */
class ButtonGroup extends FlxTypedGroup<MenuButton>
{

	public function new()
	{
		super(100);
	}

	public function init(isAlive:Bool)
	{
		for(obj in this)
		{
			obj.activated = isAlive;
			for (comp in obj.components)
			{
				if (isAlive) comp.alpha = 1;
				if (!isAlive) comp.alpha = 0;
			}
		}
	}
}

/**
 *  Button Class
 */
class Button extends FlxGroup
{
	/**
	 *  These variables have x,y
	 */
	public var hitbox:FlxObject;
	public var graphic:FlxSprite;
	public var textObject:FlxText;

	/**
	 *  Bools for checking if variable is inited
	 */
	public var hasGraphic:Bool = false;
	public var hasText:Bool = false;

	public var isAlive:Bool = false;

	public var fontHeight:Int;

	public var components:FlxTypedGroup<FlxSprite> = new FlxTypedGroup(10);

	public function new(x:Float, y:Float, ?text:String, ?fitText:Bool, ?hitboxWidth:Float = 64, ?hitboxHeight:Float = 64)
	{
		super(10);
		initializeHitbox(x, y, hitboxWidth, hitboxHeight);
		initializeText(textObject = new FlxText(x, y, text), Global.FONT_CRAZYCREATION, 24);
		add(hitbox);

		if (fitText)
		{
			hitbox.width = textObject.width;
			hitbox.height = fontHeight;
		}
	}

	function initializeText(text:FlxText, font:String, fontSize:Int)
	{
		// If button has text, make text object.
		if (text != null)
		{
			textObject = text;
			fontHeight = fontSize;
			text.setFormat(font, fontSize);
			addComponent(textObject);

			hasText = true;
		}
	}

	function initializeGraphics(assetPath:String, ?assetWidth:Int, ?assetHeight:Int)
	{
		graphic = new FlxSprite(hitbox.x, hitbox.y);
		graphic.loadGraphic(assetPath, true, assetWidth, assetHeight);	// Load graphic and set 'animated' to true, for the sake of using it as a spritesheet.
		graphic.animation.add("default", [0], 1, false, false, false);	// Define button states as animation frames.
		graphic.animation.add("hover", [1], 1, false, false, false);	//	|
		graphic.animation.add("down", [2], 1, false, false, false);		//	|
		addComponent(graphic);

		hasGraphic = true;
	}

	function initializeHitbox(x:Float, y:Float, width:Float, height:Float)
	{
		// Make independant hitbox object, base all collisions with this hitbox.
		hitbox = new FlxObject(x, y, width, height);
		FlxMouseEventManager.add(hitbox, onMouseDown, onMouseUp, onMouseOver, onMouseOut);
	}

	public function addComponent(object:FlxSprite)
	{
		components.add(object);
		add(object);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function onMouseDown(_) { if (hasGraphic) graphic.animation.play("down", true, false, 2); }
	function onMouseUp(_) { if (hasGraphic) graphic.animation.play("hover", true, false, 1); }
	function onMouseOver(_) { if (hasGraphic) graphic.animation.play("hover", true, false, 1); }
	function onMouseOut(_) { if (hasGraphic) graphic.animation.play("default", true, false, 0); }
}

/**
 *  MenuButton Class
 */
class MenuButton extends Button
{

	public var original_x:Float;
	public var original_y:Float;
	
	private var hoveredTween:FlxTween;
	private var clickedTween:FlxTween;

	private var currentMenu:ButtonGroup;
	private var targetMenu:ButtonGroup;

	public var activated:Bool = true;

	public function new(x:Float, y:Float, ?text:String, ?fitText:Bool, ?hitboxWidth:Float = 64, ?hitboxHeight:Float = 64, ?currentMenu:ButtonGroup, ?targetMenu:ButtonGroup)
	{
		super(x, y, text, fitText, hitboxWidth, hitboxHeight);
		original_x = x;
		original_y = y;
		this.currentMenu = currentMenu;
		this.targetMenu = targetMenu;
	}

	public function nextAnimate(spacing:Float)
	{
		// Phase out current menu
		for (button in currentMenu)
		{
			for(component in button.components)
			{
				button.activated = false;
				FlxTween.tween(component, {x: original_x - spacing}, 0.2, {ease: FlxEase.quadOut});
				FlxTween.tween(component, {alpha: 0}, 0.1, {ease: FlxEase.quadOut});
				FlxTween.tween(button.hitbox, {x: original_x - spacing}, 0.2, {ease: FlxEase.quadOut});
			}
		}

		// Phase in target menu
		for (button in targetMenu)
		{
			for(component in button.components)
			{
				button.activated = true;
				button.original_x = original_x;
				FlxTween.tween(component, {x: original_x}, 0.2, {ease: FlxEase.quadOut});
				FlxTween.tween(component, {alpha: 1}, 0.1, {ease: FlxEase.quadOut});
				FlxTween.tween(button.hitbox, {x: original_x}, 0.2, {ease: FlxEase.quadOut});
			}
		}
	}

	public function previousAnimate(spacing:Float)
	{
		// Phase out current menu
		for (button in currentMenu)
		{
			for(component in button.components)
			{
				button.activated = false;
				FlxTween.tween(component, {x: original_x + spacing}, 0.2, {ease: FlxEase.quadOut});
				FlxTween.tween(component, {alpha: 0}, 0.1, {ease: FlxEase.quadOut});
				FlxTween.tween(button.hitbox, {x: original_x + spacing}, 0.2, {ease: FlxEase.quadOut});
			}
		}

		// Phase in target menu
		for (button in targetMenu)
		{
			for(component in button.components)
			{
				button.activated = true;
				button.original_x = original_x;
				FlxTween.tween(component, {x: original_x}, 0.2, {ease: FlxEase.quadOut});
				FlxTween.tween(component, {alpha: 1}, 0.1, {ease: FlxEase.quadOut});
				FlxTween.tween(button.hitbox, {x: original_x}, 0.2, {ease: FlxEase.quadOut});
			}
		}
	}

	override public function onMouseDown(_)
	{
		super.onMouseDown(_);
		if (clickedTween != null) clickedTween.cancel();
		if (activated) clickedTween = FlxTween.tween(textObject, {y:original_y + 2}, 0.1, {ease: FlxEase.quadOut});
	}

	override public function onMouseUp(_)
	{
		super.onMouseUp(_);
		if (clickedTween != null) clickedTween.cancel();
		if (activated) clickedTween = FlxTween.tween(textObject, {y:original_y}, 0.1, {ease: FlxEase.quadOut});
	}

	override public function onMouseOver(_)
	{
		super.onMouseOver(_);
		if (hoveredTween != null) hoveredTween.cancel();
		if (activated) hoveredTween = FlxTween.tween(textObject, {x: original_x+5}, 0.15, {ease: FlxEase.quadOut});
	}

	override public function onMouseOut(_)
	{
		super.onMouseOut(_);
		if (hoveredTween != null) hoveredTween.cancel();
		if (activated) hoveredTween = FlxTween.tween(textObject, {x: original_x}, 0.15, {ease: FlxEase.quadOut});
	}
}

/**
 *  StartButton subclass
 */
class StartButton extends MenuButton
{

	public function new(x:Float, y:Float, ?currentMenu:ButtonGroup, ?targetMenu:ButtonGroup)
	{
		super(x, y, "start", true, 64, 64, currentMenu, targetMenu);
	}

	override public function onMouseUp(_)
	{
		super.onMouseUp(_);
		// do logic - animate menu to 
		// new game, load game, multiplayer
		
		nextAnimate(160);

	}
}

/**
 *  QuitButton subclass
 */
class QuitButton extends MenuButton
{
	public function new(x:Float, y:Float)
	{
		super(x, y, "quit", true);
	}

	override public function onMouseUp(_)
	{
		super.onMouseUp(_);
		if (activated) System.exit(0);
		// do quit logic
	}
}

/**
 *  NewGameButton Class
 */
class NewGameButton extends MenuButton
{
	public function new(x:Float, y:Float, ?currentMenu:ButtonGroup, ?targetMenu:ButtonGroup)
	{
		super(x, y, "new game", true, 0, 0, currentMenu, targetMenu);
	}

	override public function onMouseUp(_)
	{
		super.onMouseUp(_);
		// next menu
	}
}

/**
 *  PreviousMenu Class
 */
class PreviousMenuButton extends MenuButton
{
	public function new(x:Float, y:Float, ?currentMenu:ButtonGroup, ?targetMenu:ButtonGroup)
	{
		super(x, y, "back", true, 0, 0, currentMenu, targetMenu);
	}

	override public function onMouseUp(_)
	{
		super.onMouseUp(_);
		// previous menu
		if (activated) previousAnimate(160);
	}
}
