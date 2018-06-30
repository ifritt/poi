package object.ui;

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
		/* Main Menu */
		var mainMenu:ButtonGroup = new ButtonGroup();
		var startButton = new StartButton(100, 400);
		var quitButton = new QuitButton(100, 430);
		mainMenu.add(startButton);
		mainMenu.add(quitButton);
		
		/* Start submenu */

		/* New Game submenu */

		/* Load submenu */

		add(mainMenu);
	}
}

// class Background extends FlxGroup
// {
// 	public function new()
// 	{
// 		super(100);
// 	}
// }

/**
 *  ButtonGroup class
 */
class ButtonGroup extends FlxTypedGroup<Button>
{
	public function new()
	{
		super(100);
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
	public var text:FlxText;

	/**
	 *  Bools for checking if variable is inited
	 */
	public var hasGraphic:Bool = false;
	public var hasText:Bool = false;

	public var fontHeight:Int;

	public var components:FlxGroup = new FlxGroup(10);

	public function new(x:Float, y:Float, ?text:String, ?fitText:Bool, ?hitboxWidth:Float = 64, ?hitboxHeight:Float = 64)
	{
		super(10);
		initializeHitbox(x, y, hitboxWidth, hitboxHeight);
		initializeText(this.text = new FlxText(x, y, text), Global.FONT_CRAZYCREATION, 24);
		add(hitbox);

		if (fitText)
		{
			hitbox.width = this.text.width;
			hitbox.height = fontHeight;
		}
	}

	function initializeText(text:FlxText, font:String, fontSize:Int)
	{
		// If button has text, make text object.
		if (text != null)
		{
			this.text = text;
			fontHeight = fontSize;
			text.setFormat(font, fontSize);
			add(this.text);

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
		add(graphic);

		hasGraphic = true;
	}

	function initializeHitbox(x:Float, y:Float, width:Float, height:Float)
	{
		// Make independant hitbox object, base all collisions with this hitbox.
		hitbox = new FlxObject(x, y, width, height);
		FlxMouseEventManager.add(hitbox, onMouseDown, onMouseUp, onMouseOver, onMouseOut);
	}

	override public function add(object:FlxBasic):FlxBasic
	{
		components.add(object);
		return super.add(object);
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

	private var nextMenu:ButtonGroup;

	public function new(x:Float, y:Float, ?text:String, ?fitText:Bool, ?hitboxWidth:Float = 64, ?hitboxHeight:Float = 64, ?nextMenu:ButtonGroup)
	{
		super(x, y, text, fitText, hitboxWidth, hitboxHeight);
		original_x = x;
		original_y = y;
		this.nextMenu = nextMenu;
	}

	public function setNextMenu(nextMenu:ButtonGroup)
	{
		/* Don't use if already initialized in constructor */
		this.nextMenu = nextMenu;
	}

	override public function onMouseDown(_)
	{
		super.onMouseDown(_);
		if(clickedTween != null) clickedTween.cancel();
		clickedTween = FlxTween.tween(text, {y:original_y + 2}, 0.1, {ease: FlxEase.quadOut});
	}

	override public function onMouseUp(_)
	{
		super.onMouseUp(_);
		if(clickedTween != null) clickedTween.cancel();
		clickedTween = FlxTween.tween(text, {y:original_y}, 0.1, {ease: FlxEase.quadOut});
	}

	override public function onMouseOver(_)
	{
		super.onMouseOver(_);
		if(hoveredTween != null) hoveredTween.cancel();
		hoveredTween = FlxTween.tween(text, {x: original_x+5}, 0.15, {ease: FlxEase.quadOut});
	}

	override public function onMouseOut(_)
	{
		super.onMouseOut(_);
		if(hoveredTween != null) hoveredTween.cancel();
		hoveredTween = FlxTween.tween(text, {x: original_x}, 0.15, {ease: FlxEase.quadOut});
	}
}

/**
 *  StartButton subclass
 */
class StartButton extends MenuButton
{

	public function new(x:Float, y:Float)
	{
		super(x, y, "start", true);
	}

	override public function onMouseUp(_)
	{
		super.onMouseUp(_);
		// do logic - animate menu to 
		// new game, load game, multiplayer
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
		// do quit logic
	}
}