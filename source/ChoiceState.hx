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

    static var menuId = MENU_NARRATIVE;

    static inline var MENU_CONTROLS = 0;
    static inline var MENU_HIRING = 1;
    static inline var MENU_NARRATIVE = 2;
    static inline var MENU_DIALOGUE_1 = 3;
    static inline var MENU_DIALOGUE_2 = 4;
    static inline var MENU_GAMEPLAY_1 = 5;
    static inline var MENU_GAMEPLAY_2 = 6;
    static inline var MENU_PRE_BOSS = 7;

    static inline var MENU_END = MENU_PRE_BOSS + 1;

    public static var hireBonus = -1;
    public static var streamerBonus = -1;
    public static var journalistBonus = -1;
    public static var dialogueOrGameplay = -1;

    var skip = false;
    var blackness: FlxSprite;
    var textAnnounce: Text;

    public static function reset()
    {
        CatZima.allowKeyboard = true;
        CatZima.allowGamepad = true;

        menuId = MENU_CONTROLS;

        hireBonus = -1;
        streamerBonus = -1;
        journalistBonus = -1;
        dialogueOrGameplay = -1;
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
                text2 = "Выбор 2: Нанять модератора\n\nСледствие: Повышение уровня сетевого здоровья";
            
            case MENU_NARRATIVE:
                text1 = "Выбор 1: Выбор - через диалоги\n\nСледствие: Хардкорные игроки недовольны";
                text2 = "Выбор 2: Выбор - через геймплей\n\nСледствие: У знакомых стримеров недовольны зрители";
            
           /* case MENU_DIALOGUE_1:
                text1 = "Выбор 1: Выбор - через диалоги\n\nСледствие: Хардкорные игроки недовольны";
                text2 = "Выбор 2: Выбор - через геймплей\n\nСледствие: У знакомых стримеров недовольны зрители";*/

            case MENU_DIALOGUE_2:
                text1 = "Выбор 1: Выпустить игру по плану с багами\n\nСледствие: Поскорее релиз";
                text2 = "Выбор 2: Отодвинуть релиз из-за багов\n\nСледствие: Попытаемся исправить их";
            
            case MENU_PRE_BOSS:
                text1 = "Выбор 1: Последняя битва\n\nСледствие: Показать ракам, где они зимуют";
                text2 = "Выбор 2: Сдаться и пойти поспать\n\nСледствие: Сон - лучшее лекарство";

            case MENU_END:
                player.allowMove = false;

            default:
                skip = true;
        }

        var choice1: ChoiceButton;
        var choice2: ChoiceButton;

        if (menuId == MENU_PRE_BOSS)
        {
            choice1 = new ChoiceButton(text1, 0, -5, 10, 1.1/3, "Slot_red");
            choice2 = new ChoiceButton(text2, 0, 120, 10, 1.1/3, "Slot_blue");

            if (dialogueOrGameplay == 1)
                skip = true;
        }
        else
        {
            choice1 = new ChoiceButton(text1, 0, -5, 10, 1.1/3, null);
            choice2 = new ChoiceButton(text2, 0, 120, 10, 1.1/3, null);
        }

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

        //CatZimaState.musicInter();

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

        if (!blackness.visible)
            CatZimaState.musicInter();

        if (skip && !blackness.visible)
            choice = 0;

        if (choice >= 0)
        {
            choiceMade(choice);
        }
        
	}

    function choiceMade(choice: Int)
    {
        var noIncrement = false;
        switch (menuId)
        {
            case MENU_CONTROLS:
                CatZima.allowKeyboard = (choice == 0);
                CatZima.allowGamepad = (choice == 1);

                PlayState.enemiesToSpawn = [units.Casual, units.Casual, units.Casual, units.Casual, units.Casual];
                BriefingState.hintId = BriefingState.HINT_BLONDE;

            case MENU_HIRING:
                hireBonus = choice;
                PlayState.enemiesToSpawn = [units.Casual, units.Casual, units.Casual, units.Troll, units.Casual, units.Casual, units.Troll, units.Casual, units.Casual];
               // PlayState.enemiesToSpawn = [units.Casual, units.Troll, units.Casual, units.Casual, units.Troll];
                //trace(112233);
                BriefingState.hintId = BriefingState.HINT_TROLL;
                

            case MENU_NARRATIVE:
                dialogueOrGameplay = choice;
                if (choice == 0)
                {
                    PlayState.enemiesToSpawn = [units.Casual, units.Hardcore, units.Casual, units.Casual, units.Hardcore, units.Hardcore];
                    BriefingState.hintId = BriefingState.HINT_HARDCORE;
                }
                else
                {
                    PlayState.enemiesToSpawn = [units.Streamer, units.Casual, units.Streamer, units.Casual, units.Casual, units.Streamer];
                    BriefingState.hintId = BriefingState.HINT_STREAMER;
                }
            
            case MENU_NARRATIVE:
                if (choice == 0)
                {
                    PlayState.enemiesToSpawn = [units.Casual, units.Hardcore, units.Casual, units.Casual, units.Hardcore, units.Hardcore];
                    BriefingState.hintId = BriefingState.HINT_HARDCORE;

                    menuId = MENU_DIALOGUE_1;
                }
                else
                {
                    PlayState.enemiesToSpawn = [units.Streamer, units.Casual, units.Streamer, units.Casual, units.Casual, units.Streamer];
                    BriefingState.hintId = BriefingState.HINT_STREAMER;

                    menuId = MENU_GAMEPLAY_1;
                }

                noIncrement = true;
            
            case MENU_GAMEPLAY_1:
                if (streamerBonus == -1)
                    BriefingState.hintId = BriefingState.HINT_STREAMER_KILL;
                else
                    BriefingState.hintId = BriefingState.HINT_STREAMER_SAVE;

            case MENU_DIALOGUE_2:
                if (choice == 0)
                    journalistBonus = 0;
                
                menuId = MENU_PRE_BOSS;

                noIncrement = true;

            default: {}
        }

        if (!noIncrement)
            ++menuId;

        FlxG.switchState(new BriefingState());
    }

}