package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import units.CatZima;

class ChoiceState extends CatZimaState
{
    var player: units.CatZima;
    var choices: Array<ChoiceButton>;

    static var menuId = MENU_HIRING;

    static inline var MENU_CONTROLS = 0;
    static inline var MENU_HIRING = 1;
    static inline var MENU_NARRATIVE = 2;

    public static var hireBonus = -1;

	override public function create():Void
	{
		super.create();

        var text1 = "";
        var text2 = "";

        switch (menuId)
        {
            case MENU_CONTROLS:
                text1 = "Выбор 1: Эксклюзивно на ПК\n\nСледствие: Управление клавиатурой";
                text2 = "Выбор 2: Эксклюзивно на консоль\n\nСледствие: Управление геймпадом";
            
            case MENU_HIRING:
                text1 = "Выбор 1: Нанять сисадмина\n\nСледствие: Быстрее связь - больше твитов";
                text2 = "Выбор 2: Нанять модератора\n\nСледствие: Меньше дистресса - больше здоровья";
            
            //case MENU_NARRATIVE:
                //text1 = "Выбор 1: Эксклюзивно на ПК\n\nСледствие: Управление клавиатурой";
                //text2 = "Выбор 2: Эксклюзивно на консоль\n\nСледствие: Управление геймпадом";

            default:
                choiceMade(0);
        }

        var choice1 = new ChoiceButton(text1, 0, 0, 10, 1/3);
        var choice2 = new ChoiceButton(text2, 0, 120, 10, 1/3);
        choices = [ choice1, choice2 ];

        player = CatZimaState.player;

        //player.reset(FlxG.width / 2 - player.width / 2, FlxG.height / 2 - player.height / 2);
		
        for (c in choices)
        {
            add(c);
        }

        add(player);
        add(CatZimaState.playerBullets);

        player.allowShoot = false;
        //player.waitToAllowMove = true;
        player.waitMoveTimer = 1.0;
        //player.allowMove = false;

        bgColor = 0;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        var choice = -1;

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
            choiceMade(choice);
        }
        
	}

    function choiceMade(choice: Int)
    {
        switch (menuId)
        {
            case MENU_CONTROLS:
                CatZima.allowKeyboard = (choice == 0);
                CatZima.allowGamepad = (choice == 1);

                PlayState.enemiesToSpawn = [units.Casual, units.Casual, units.Casual, units.Casual, units.Casual];
                BriefingState.hintId = BriefingState.HINT_BLONDE;

                hireBonus = -1;

            case MENU_HIRING:
                hireBonus = choice;
                PlayState.enemiesToSpawn = [units.Casual, units.Casual, units.Troll, units.Casual, units.Troll, units.Casual];
                BriefingState.hintId = BriefingState.HINT_TROLL;
                

            case MENU_NARRATIVE:
                PlayState.enemiesToSpawn = [units.Casual, units.Hardcore, units.Casual, units.Casual, units.Hardcore, units.Hardcore];
                BriefingState.hintId = BriefingState.HINT_HARDCORE;

            default: {}
        }

        ++menuId;

        FlxG.switchState(new BriefingState());
    }

}