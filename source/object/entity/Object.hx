package object.entity;

import flixel.*;
import flixel.graphics.*;

class Object extends FlxSprite
{
    private var _isPhysicsObject:Bool;
    
    public var z(default, set):Float;
    public var weight(default, set):Float = 1;

    public inline function new(x:Float, y:Float, ?sprite:FlxGraphic, ?isPhysicsObject:Bool)
    {
        super(x, y, sprite);
        _isPhysicsObject = isPhysicsObject;
    }

    public override function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    function set_z(value):Float
    {
        return z = value;
    }

    function set_weight(value):Float
    {
        return weight = value;
    }
}