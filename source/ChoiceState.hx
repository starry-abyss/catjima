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

    static var menuId = MENU_CONTROLS;

    static inline var MENU_CONTROLS = 0;
    static inline var MENU_HIRING = 1;
    static inline var MENU_NARRATIVE = 2;

    static inline var MENU_END = 3;

    public static var hireBonus = -1;

    var skip = false;
    var blackness: FlxSprite;
    var textAnnounce: Text;

    public static function reset()
    {
        CatZima.allowKeyboard = true;
        CatZima.allowGamepad = true;

        menuId = MENU_CONTROLS;

        hireBonus = -1;
    }

	override public function create():Void
	{
		super.create();

        skip = false;

        var background = new FlxSprite();
        background.loadGraphic("assets/images/background.png");
        background.scrollFactor.set();
        add(background);

        player = CatZimaState.player;

        var text1 = "";
        var text2 = "";
        var text0 = "";

        text0 = "В следующем месяце...";

        switch (menuId)
        {
            case MENU_CONTROLS:
                reset();

                player.allowMove = true;

                text1 = "Выбор 1: Релиз только на ПК\n\nСледствие: Управление клавиатурой";
                text2 = "Выбор 2: Релиз только на консоль\n\nСледствие: Управление геймпадом";
            
            case MENU_HIRING:
                text1 = "Выбор 1: Нанять сисадмина\n\nСледствие: Ускорение отправки твитов";
                text2 = "Выбор 2: Нанять модератора\n\nСледствие: Поднятие уровня сетевого здоровья";
            
            //case MENU_NARRATIVE:
                //text1 = "Выбор 1: Эксклюзивно на ПК\n\nСледствие: Управление клавиатурой";
                //text2 = "Выбор 2: Эксклюзивно на консоль\n\nСледствие: Управление геймпадом";

            case MENU_END:
                player.allowMove = false;

            default:
                skip = true;
        }

        var choice1 = new ChoiceButton(text1, 0, -5, 10, 1.1/3);
        var choice2 = new ChoiceButton(text2, 0, 120, 10, 1.1/3);
        choices = [ choice1, choice2 ];

        //player.reset(FlxG.width / 2 - player.width / 2, FlxG.height / 2 - player.height / 2);
		
        if (menuId != MENU_END)
        {
            for (c in choices)
            {
                add(c);
            }

            add(player);
            add(CatZimaState.playerBullets);

            player.allowShoot = false;
            //player.waitToAllowMove = true;

            if (menuId != MENU_CONTROLS)
                player.waitMoveTimer = 2.0;

            //player.allowMove = false;
        }

        bgColor = 0;

        if (menuId == MENU_CONTROLS)
        {
            var keyHintText = new Text("Для выбора\nиспользуйте:");
            keyHintText.reset(20, 60);
            keyHintText.color = 0xff000000;
            add(keyHintText);

            var keyHint1 = new FlxSprite();
            keyHint1.scrollFactor.set();
            add(keyHint1);

            keyHint1.loadGraphic("assets/images/ui/WASD Move.png");
            keyHint1.reset(35, 90);

            var keyHint2 = new FlxSprite();
            keyHint2.scrollFactor.set();
            add(keyHint2);

            keyHint2.loadGraphic("assets/images/ui/joypad dpad.png");
            keyHint2.reset(85, 90);
        }

        CatZimaState.musicMenu();

        blackness = new FlxSprite();
        blackness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
        blackness.scrollFactor.set();
        add(blackness);

        textAnnounce = new Text(text0);
        textAnnounce.reset(FlxG.width / 2 - textAnnounce.width / 2, FlxG.height / 2 - textAnnounce.height / 2);
        add(textAnnounce);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        var choice = -1;

        if (menuId == MENU_CONTROLS)
        {
            if (player.velocity.y != 0.0)
            {
                if (CatZima.movingWithGamepad && ((player.velocity.y > 0) == (choices[0].y > choices[1].y)))
                {
                    var x = choices[0].x;
                    var y = choices[0].y;
                    choices[0].moveTo(choices[1].x, choices[1].y);
                    choices[1].moveTo(x, y);
                }

                if (CatZima.movingWithKeyboard && ((player.velocity.y > 0) == (choices[0].y < choices[1].y)))
                {
                    var x = choices[0].x;
                    var y = choices[0].y;
                    choices[0].moveTo(choices[1].x, choices[1].y);
                    choices[1].moveTo(x, y);
                }
            }
        }

        for (i in 0...choices.length)
        {
            if (choices[i].overlaps(player))
            {
                choice = i;
                break;
            }
        }

        blackness.visible = (player.waitMoveTimer > 0.0);
        textAnnounce.visible = blackness.visible;

        if (skip && !blackness.visible)
            choice = 0;

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
                PlayState.enemiesToSpawn = [units.Casual, units.Casual, units.Troll, units.Casual, units.Casual, units.Troll, units.Casual, units.Casual, units.Casual];
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