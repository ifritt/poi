package ;

import flixel.*;

import object.ui.Transition;
import object.ui.Dialog;

class PoiState extends FlxState
{
    public var transition:Transition;
    public var dialogEngine:Dialog;

    override public function create():Void
    {
        super.create();

        dialogEngine = new Dialog(50, 500);
        add(dialogEngine);
		
        transition = new Transition(this);
        transition.transitionIn(TransitionType.NORMAL, null);
    }
}