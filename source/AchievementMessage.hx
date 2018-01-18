package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxSave;

class AchievementMessage extends ChoiceButton
{

    static var singleton: AchievementMessage = null;

    var timeLeft: Float;

    public static function init(): AchievementMessage
    {
        if (singleton == null)
        {
            singleton = new AchievementMessage();

            hideMessage();
        }

        return singleton;
    }

    private function new()
    {
        super("", 0, 145, 10, 2.3/10, null, "Slot");


    }

    public static function showMessage(text: String)
    {
        init();

        singleton.setText("Новый значок: " + text);
        singleton.visible = true;
        singleton.timeLeft = 3.0;
    }

	/*override public function create():Void
	{
		super.create();

        init();

        //add(message);
	}*/

    static function hideMessage()
    {  
        singleton.timeLeft = 0.0;
        singleton.visible = false;
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        timeLeft -= elapsed;
        if (timeLeft <= 0.0)
        {
            hideMessage();
        }
	}

    override public function destroy():Void
	{
        //do nothing
    }

}