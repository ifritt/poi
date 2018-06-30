package object.ui;

import flixel.*;
import flixel.group.*;
import flixel.util.*;
import flixel.text.FlxText;
import flixel.math.*;
import flixel.tweens.*;

import flixel.input.mouse.FlxMouseEventManager;

class Button extends FlxGroup
{
    private var index:Int;
    private var x:Float = 0;
    private var y:Float = 0;

    var graphic:FlxSprite;
    var textObject:FlxText;
    var text:String;

    var hitbox:FlxObject;

    var hovered:Bool = false;

    var buttonDefault:String = "assets/img/button_default.png";
    var buttonHover:String = "assets/img/button_hover.png";
    var buttonDown:String = "assets/img/button_down.png";

    public function new(x:Float, y:Float, ?width:Float, ?height:Float, ?text:String, ?fontSize:Int)
    {
        super(100);
        this.x = x;
        this.y = y;

        graphic = new FlxSprite(x, y);
        add(graphic);

        if (text != "")
        {
            this.text = text;
            textObject = new FlxText(x, y, text);
            textObject.setFormat(Global.FONT_CRAZYCREATION, fontSize);
            add(textObject);
        }

        hitbox = new FlxObject(x, y, 64, 64);
        add(hitbox);

        // setup mouse events
        FlxMouseEventManager.add(graphic, onMouseDown, onMouseUp, onMouseHover, onMouseOut);
        // FlxMouseEventManager.add(textObject, onMouseDown, onMouseUp, onMouseHover, onMouseOut);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    function onMouseDown(sprite:FlxSprite)
    {
        sprite.loadGraphic(buttonDown);
    }

    function onMouseHover(sprite:FlxSprite)
    {
        sprite.loadGraphic(buttonHover);
        hovered = true;
    }

    function onMouseOut(sprite:FlxSprite)
    {
        sprite.loadGraphic(buttonDefault);
        hovered = false;
    }

    function onMouseUp(sprite:FlxSprite)
    {
        sprite.loadGraphic(buttonHover);
    }
}

class StartButton extends Button
{
    public var tween:FlxTween;

    public function new(x:Float, y:Float, menuParent:FlxGroup)
    {
        super(x, y, "", 65);
        graphic.makeGraphic(64, 96, 0x00000000);

    }
    
    var tempX:Float;
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
    
    override function onMouseHover(sprite:FlxSprite)
    {
        super.onMouseHover(sprite);
        sprite.makeGraphic(64, 24, FlxColor.WHITE);

    }

    override function onMouseOut(sprite:FlxSprite)
    {
        super.onMouseOut(sprite);
        sprite.makeGraphic(64, 24, FlxColor.WHITE);
    }
}