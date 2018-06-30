package object.entity;

import object.ui.*;

import flixel.util.*;

class NPC extends Entity
{
    public inline function new(x:Float, y:Float, ?isPhysicsObject:Bool, ?isImmortal:Bool)
    {
        super(x, y, isPhysicsObject, isImmortal);
        makeGraphic(16, 32, FlxColor.WHITE);
    }
}