package ;

import flixel.*;

import object.ui.Transition;

class PoiState extends FlxState
{
    public var transition:Transition;

    override public function create():Void
    {
        super.create();
		
        transition = new Transition(this);
        transition.transitionIn(TransitionType.NORMAL, null);
    }
}