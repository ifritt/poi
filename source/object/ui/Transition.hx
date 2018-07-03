package object.ui;

import flixel.*;
import flixel.util.*;
import flixel.tweens.*;

class Transition
{
    public var currentState:PoiState;
    public var targetState:PoiState;

    public var transitionObject:FlxSprite;

    private var onCompleteCallback:Void->Void;

    public function new(initialState:PoiState)
    {
        currentState = initialState;
        transitionObject = new FlxSprite(0, 0);
        initialState.add(transitionObject);
        trace("transition class inited");
    }

    /**
     *  Start the transition in animation.
     *  @param transitionType - An integer value. e.g TransitionType.NORMAL
     *  @param onComplete - Callback function.
     */
    public function transitionIn(transitionType:Int, onComplete:Void->Void)
    {
        onCompleteCallback = onComplete;
        switch (transitionType)
        {
            case -1:
            {
                // normal transition animation. instant
                normalTransitionIn(0);
            }
            case 0:
            {
                // normal transition animation.
                normalTransitionIn(0.5);
            }
        }
    }

    /**
     *  Start the transition out animation.
     *  @param transitionType - An integer value. e.g TransitionType.NORMAL
     *  @param onComplete - Callback function.
     */
    public function transitionOut(transitionType:Int, onComplete:Void->Void)
    {
        onCompleteCallback = onComplete;
        switch (transitionType)
        {
            case -1:
            {
                // normal transition animation. instant
                normalTransitionOut(0);
            }
            case 0:
            {
                // normal transition animation.
                normalTransitionOut(0.5);
            }
        }
    }

    /**
     *  Transition In
     */
    private function normalTransitionIn(delay:Float)
    {
        transitionObject.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        FlxTween.tween(transitionObject, {x: FlxG.width}, 0.3, {ease: FlxEase.quadOut, onComplete: onComplete, startDelay: delay});
    }

    /**
     *  Transition Out
     */
    private function normalTransitionOut(delay:Float)
    {
        transitionObject.setPosition(FlxG.width, 0);
        transitionObject.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        FlxTween.tween(transitionObject, {x: 0}, 0.3, {ease: FlxEase.quadOut, onComplete: onComplete, startDelay: delay});
    }

    private function onComplete(tween:FlxTween)
    {
        if (onCompleteCallback != null) onCompleteCallback();
    }
}

class TransitionType
{
    public static var INSTANT(default, null):Int = -1;
    public static var NORMAL(default, null):Int = 0;
}