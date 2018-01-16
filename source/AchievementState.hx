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

    static var singleton: AchievementState = null;

    public static function init(): AchievementState
    {
        if (singleton == null)
        {
            singleton = new AchievementState();
            //singleton.persistentDraw = true;
            //singleton.persistentUpdate = true;
        }

        return singleton;
    }

    /*public static function isOpen()
    {
        //init();

        //return singleton.visible;
    }*/

    /*public static function unlock()
    {

    }*/

	override public function create():Void
	{
		super.create();

        choices = new Map<String, ChoiceButton>();

        //choices[""] = new ChoiceButton("Управление клавиатурой", 0, 0, 10, 1/3, "units/");
        //choices[""] = new ChoiceButton("Управление геймпадом", 0, 120, 10, 1/3, "");

        //choices = [ choice1, choice2 ];

        //player = CatZimaState.player;

        //player.reset(FlxG.width / 2 - player.width / 2, FlxG.height / 2 - player.height / 2);
		
        /*for (c in choices.keys())
        {
            add(choices.get(c));
        }*/

        //add(player);
        // add(CatZimaState.playerBullets);

        //player.allowShoot = false;

        slot = 0;

        register("fail", "Дамский угодник", "units/blonde");
        register("hehe", "Тонкая грань", "units/trololoshka");
        register("message", "Твит-машина", "units/tweetMaster");

        //register("buggy", "Ничейное небо: выпустить игру с багами", "units/bug");
        register("help", "Это - фича", "units/bug");
        
        register("health", "Личный контакт", "units/health");
        register("nospoon", "Послед-\nние 10%", "units/boss");
        

        bgColor = 0;

        updateAchievements();
	}

    function updateAchievements()
    {
        //unlockedAchievements
    }

    var slot: Int = 0;
    function register(id: String, text: String, icon: String = null)
    {
        var choice = new ChoiceButton(text, slot % 2 == 0 ? 5 : 170, 70 + 30 * Math.floor(slot / 2), 0, 1/4, icon, "Slot_blue", 1/2.2);

        add(choice);
        choices.set(id, choice);

        ++slot;
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