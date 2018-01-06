package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class AchievementState extends FlxSubState
{
    //var player: units.CatZima;
    var choices: Map<String, ChoiceButton>;

    static var unlockedAchievements: Array<String> = [];

	override public function create():Void
	{
		super.create();

        choices = new Map<String, ChoiceButton>();

        //choices[""] = new ChoiceButton("Управление клавиатурой", 0, 0, 10, 1/3, "units/");
        //choices[""] = new ChoiceButton("Управление геймпадом", 0, 120, 10, 1/3, "");

        //choices = [ choice1, choice2 ];

        //player = CatZimaState.player;

        //player.reset(FlxG.width / 2 - player.width / 2, FlxG.height / 2 - player.height / 2);
		
        for (c in choices.keys())
        {
            add(choices.get(c));
        }

        //add(player);
        // add(CatZimaState.playerBullets);

        //player.allowShoot = false;

        bgColor = 0;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        /*var choice = -1;

        for (i in 0...choices.length)
        {
            if (choices[i].overlaps(player))
            {
                choice = i;
                break;
            }
        }

        if (choice >= 0)
        {
            FlxG.switchState(new BriefingState());
        }*/
        
	}

}