package object.ui;

import flixel.text.*;
import flixel.group.*;
import flixel.util.*;
import flixel.math.*;
import flixel.system.*;
import flixel.*;

class Dialog extends FlxGroup
{
    public var fontSize:Int;

    public var speakerName:String;
    public var lines:Array<Line>;

    public var characters:FlxGroup;

    private var delayCounter:Int = 0;
    private var delayCounterMax:Int = 4;

    private var currentCharacter:Int = 0;
    private var currentLine:Int = 0;

    private var dialog_x:Float = 0;
    private var dialog_y:Float = 0;
    
    private var letter_x:Float = 0;
    private var line_break_y:Float = 0;

    private var sound:FlxSound;

    var speaking:Bool = false;
    var paused:Bool = false;

    var dialogImmunity:Bool = false;

    public var activeEffect:Int = LetterEffect.NONE;

    // debug
    // var speakingBool:FlxText;

    /* variables for rendering letters and when to cut off to split lines */

    public function new(x:Float, y:Float, ?fontSize:Int = 24)
    {
        super();
        dialog_x = x;
        dialog_y = y;

        sound = FlxG.sound.load("assets/audio/bleep.ogg");

        this.fontSize = fontSize;

        characters = new FlxGroup();
        add(characters);

        // debug
        // speakingBool = new FlxText(10, 500, "false");
        // if(speaking) speakingBool.text = "true";
        // speakingBool.setFormat(Global.FONT_CRAZYCREATION, 32, FlxColor.BLACK);
        // add(speakingBool);

        trace("dialog class inited");
    }

    // TODO: Increase functionality
    //       Scan letter, if == ` , do not draw. Instead, scan every letter after that until it hits another `. 
    //       All letters detected will form a keyword which will format every letter after that.
    //       There must be a default keyboard to reset everything.

    // DONE: pause
    // 
    private function drawLetter()
    {
        var char = lines[currentLine].text.charAt(currentCharacter);

        // if pause symbol, pause. else, keep drawing.
        if (char == "\\") 
        {
            paused = true;
        } else if(char == "`")
        {
            // increment once to skip the first identifier.
            currentCharacter++;
            var keyword = "";
            for(i in currentCharacter...lines[currentLine].text.length)
            {
                if (lines[currentLine].text.charAt(i) == "`") 
                {
                    // now, skip it the same amount of times as the length of the keyword.
                    currentCharacter += keyword.length;
                    
                    // set activeEffect 
                    handleKeywords(keyword);

                    break; // and break the loop.
                }
                keyword += lines[currentLine].text.charAt(i);
            }
        } else
        {
            // calculate every letter's supposed position.
            var lx:Float = dialog_x + (14 * letter_x);
            var ly:Float = dialog_y + (line_break_y * fontSize);
            // create a Letter object for every letter inside a line.
            var letter = new Letter(lx, ly, char, fontSize, activeEffect);
            characters.add(letter);
            letter_x++;
        }

    }

    private function handleKeywords(keyword:String)
    {
        switch(keyword)
        {
            case "shake":
            {
                activeEffect = LetterEffect.SHAKE;
            }
            case "none":
            {
                activeEffect = LetterEffect.NONE;
            }
        }
    }

    public function speak(lines:Array<Line>)
    {
        if (!Global.IN_DIALOG && !dialogImmunity)
        {
            Global.IN_DIALOG = true;
            this.lines = lines;
            speaking = true;
            paused = false;
            dialogImmunity = false;

            trace("now in a dialog");
        }
    }

    public function continueDialog()
    {
        // if still speaking, but not paused, shut him up, draw all remaining letters, and end the line. prepare for next line
        // but if speaking, and paused, continue his line.
        if (speaking)
        {
            if (paused)
            {
                paused = false;
            }else
            {
                speaking = false;
                for (i in currentCharacter...lines[currentLine].text.length)
                {
                    if (lines[currentLine].text.charAt(i) == "\\") 
                    {
                        paused = true;
                        speaking = true;
                        currentCharacter++;
                        handleLineBreaking();
                        break;
                    }
                    drawLetter();
                    currentCharacter++;
                    handleLineBreaking();
                }
            }
        } else
        {
            // else if already finished speaking, move onto next line. and start speaking again.
            if (currentLine < lines.length - 1)
            {
                // reset
                currentCharacter = 0;
                letter_x = 0;
                characters.clear();
                // and start speaking the next line.
                currentLine++;
                speaking = true;
            } else 
            {
                // but if it is already the last line, end the conversation with finish().
                finish();
            }
        }
    }

    public function finish()
    {
        speaking = false;
        currentCharacter = 0;
        letter_x = 0;
        line_break_y = 0;
        characters.clear();
        Global.IN_DIALOG = false;
        currentLine = 0;
        dialogImmunity = true;
        trace("no longer in a dialog. dialog immunity now active..");
        haxe.Timer.delay(function()
        {
            dialogImmunity = false;
            trace("dialog immunity worn off.");
        }, 1000);
    }

    function handleLineBreaking()
    {
        if (letter_x > 50)
        {
            // check if it's in the middle of rendering a word. This will only break the line if it is an empty character and line already exceeds 50 characters.
            if (lines[currentLine].text.charAt(currentCharacter) == " ")
            {
                letter_x = -1;
                line_break_y++;
            }
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (Global.IN_DIALOG)
        {
            if (speaking && !paused)
            {

                // add letters from Line object into characters FlxGroup
                drawLetter();
                
                // NOTE: This has been moved into the drawLetter() function.
                // keep incrementing this. resetting it to cut off every line will be done elsewhere.
                // letter_x++;

                if (currentCharacter < lines[currentLine].text.length) currentCharacter++;
                if (currentCharacter >= lines[currentLine].text.length) speaking = false;

                // handles line breaking.
                handleLineBreaking();

            }
            if (speaking && !paused && delayCounter >= delayCounterMax) 
            {
                delayCounter = 0;                

                sound.play(true);
            }
            delayCounter++;

            // handle finishing of line, and moving onto the next line
            if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.GRAVEACCENT && !dialogImmunity)
            {
                continueDialog();
            }
        }
    }
}

class Line {
    public var text:String;
    public var speakerName:String;

    public function new(speakerName:String, text:String)
    {
        this.speakerName = speakerName;
        this.text = text;
    }
}

class Letter extends FlxText
{

    public var original_x:Float;
    public var original_y:Float;

    private var effect:Int;

    public function new(x:Float, y:Float, letter:String, size:Int, ?effect:Int)
    {
        super(x, y, letter);
        setFormat(Global.FONT_CRAZYCREATION, size, FlxColor.BLACK);

        this.effect = effect;

        original_x = x;
        original_y = y;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        switch (effect)
        {
            case 1:
            {
                x = original_x + new FlxRandom().float(-1, 1);
                y = original_y + new FlxRandom().float(-1, 1);
            }
        }
        // shake: i.e original_x + random(5);
    }
}

class LetterEffect
{
    public static var NONE:Int = 0;
    public static var SHAKE:Int = 1;
}