package object.ui;

import flash.system.System;

import flixel.*;
import flixel.group.FlxGroup;
import flixel.text.*;
import flixel.tweens.*;
import flixel.util.*;
import flixel.input.mouse.FlxMouseEventManager;

import object.ui.Transition;
import states.*;

/**
 *  ButtonGroup class
 */
class ButtonGroup extends FlxTypedGroup<MenuButton>
{

	public function new()
	{
		super();
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

	/**
	 *  Constructor
	 *  @param x - x coordinate.
	 *  @param y - y coordinate.
	 *  @param text - Text to display.
	 *  @param fitText - Optional: Makes hitbox size fit text object size.
	 *  @param hitboxWidth - Optional: If fitText is false, specify hitboxWidth.
	 *  @param hitboxHeight - Optional: If fitText is false, specify hitboxHeight.
	 */
	public function new(x:Float, y:Float, ?text:String, ?fitText:Bool, ?hitboxWidth:Float = 64, ?hitboxHeight:Float = 64)
	{
		super(16);
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
            text.color = FlxColor.BLACK;
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

	/**
	 *  Constructor
	 *  @param x - x coordinate.
	 *  @param y - y coordinate.
	 *  @param text - Text to display.
	 *  @param fitText - Makes hitbox fit the size of the text object.
	 *  @param hitboxWidth - Optional: If fitText is false, specify hitboxWidth.
	 *  @param hitboxHeight - Optional: If fitText is false, specify hitboxHeight.
	 *  @param currentMenu - Optional: Current menu that this object is a part of.
	 *  @param targetMenu - Optional: Target menu that this object will phase in when activated.
	 */
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
				button.activated = false; // disable current(old) menu's buttons
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
				button.activated = true; // enable target menu's buttons
				button.original_x = original_x; // set target menu's original_x to current menu's original_x
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
				button.activated = false; // disable current(old) menu's buttons
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
				button.activated = true; // enable target menu's buttons
				button.original_x = original_x; // set target menu's original_x to current menu's original_x
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
		if (activated) clickedTween = FlxTween.tween(textObject, {y:original_y + 2}, 0.1, {ease: FlxEase.quadOut}); // only do tweens if active
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
		
		nextAnimate(100);
	}
}

/**
 *  QuitButton subclass
 */
class QuitButton extends MenuButton
{
	private var state:PoiState;
	public function new(x:Float, y:Float, currentState:PoiState)
	{
		super(x, y, "quit", true);
		state = currentState;
	}

	override public function onMouseUp(_)
	{
		super.onMouseUp(_);
		state.transition.transitionOut(TransitionType.INSTANT, onComplete);
		// do quit logic
		// if (activated) System.exit(0);
	}

	private function onComplete()
	{
		if (activated) System.exit(0);
	}
}

/**
 *  NewGameButton Class
 */
class NewGameButton extends MenuButton
{
    private var currentState:PoiState;
    private var targetState:PoiState;

	public function new(x:Float, y:Float, currentState:PoiState)
	{
		super(x, y, "new game", true);
        this.currentState = currentState;
	}

	override public function onMouseUp(_)
	{
		super.onMouseUp(_);
		// next menu
        targetState = new GameState();
        currentState.transition.transitionOut(TransitionType.NORMAL, onComplete);
	}

    private function onComplete()
    {
        FlxG.switchState(targetState);
    }
}

/**
 *  LoadGameButton class
 */
class LoadGameButton extends MenuButton
{
	public function new(x:Float, y:Float, ?currentMenu:ButtonGroup, ?targetMenu:ButtonGroup)
	{
		super(x, y, "load game", true, 0, 0, currentMenu, targetMenu);
	}

	override public function onMouseUp(_)
	{
		super.onMouseUp(_);
		// switch to 'load game' menu
		// also load in all saved data if any.
		if (activated) nextAnimate(100);
	}
}

/**
 *  LoadSlotButton class
 */
class LoadStateButton extends MenuButton
{
	public function new(x:Float, y:Float)
	{
		super(x, y, "load game", true);
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
		if (activated) previousAnimate(100);
	}
}
