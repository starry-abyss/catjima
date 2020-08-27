package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxSave;
import flixel.group.FlxGroup;
import openfl.system.System;

class ExitState extends FlxGroup
{

    //static var singleton: ExitState = null;

    var background: FlxSprite;
    var keyHintText: Text;

    /*public static function init(): ExitState
    {
        if (singleton == null)
        {
            singleton = new ExitState();
            //singleton.persistentDraw = true;
            //singleton.persistentUpdate = true;

        }

        return singleton;
    }*/

    public /*static*/ function isOpen()
    {
        //init();

        checkKeys();

        return background != null && /*singleton.*/background.visible;
    }

    public function new()
    {
        super();

        //background = null;

        background = new FlxSprite();
        background.loadGraphic("assets/images/LOGO-outside.png");
        background.scrollFactor.set();
        add(background);

        keyHintText = new Text("Exit - Y\n\nTo the game - Esc");
        keyHintText.reset(7, 145);

        keyHintText.color = 0xff2e5b75;
        keyHintText.borderSize = 1;
        keyHintText.borderColor = 0xff37b4ff;
        keyHintText.borderStyle = OUTLINE;
        /*keyHintText.color = 0xffffffff;
        keyHintText.borderSize = 1;
        keyHintText.borderColor = 0x80000000;
        keyHintText.borderStyle = OUTLINE;*/

        add(keyHintText);

        background.visible = false;
        keyHintText.visible = false;
    }

	/*override public function create():Void
	{
		super.create();

        
    }*/

    function checkKeys()
    {
        if (background.visible)
        {
            if (FlxG.keys.anyJustPressed(["Y"]))
            {
		System.exit(0);
                //openfl.Lib.close();
            }
        }

        if (FlxG.keys.anyJustPressed(["ESCAPE"]))
        {
            CatZimaState.playSound("confirm1.wav", 1.0);
            
            background.visible = !background.visible;

            //trace(background.visible);
        }

        keyHintText.visible = background.visible;
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        //checkKeys();
	}

}
