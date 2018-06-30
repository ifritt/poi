package object.entity;

import flixel.graphics.*;
import object.ui.*;

class Entity extends Object
{
    private var _isImmortal:Bool = true;
    private var clickable:Clickable;

    public inline function new(x:Float, y:Float, ?sprite:FlxGraphic, ?isPhysicsObject:Bool = false, ?isImmortal:Bool)
    {
        super(x, y, sprite, isPhysicsObject);
        _isImmortal = isImmortal;
    }
}