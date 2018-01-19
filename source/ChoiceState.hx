package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import units.CatZima;

class ChoiceState extends CatZimaState
{
    var player: units.CatZima;
    var choices: Array<ChoiceButton>;

    public static var menuId(default, null) = MENU_CONTROLS;

    public static inline var MENU_CONTROLS = 0;
    public static inline var MENU_HIRING = 1;
    public static inline var MENU_NARRATIVE = 2;
    public static inline var MENU_DIALOGUE_1 = 3;
    //static inline var MENU_DIALOGUE_2 = 4;
    public static inline var MENU_GAMEPLAY_1 = 5;
    //static inline var MENU_GAMEPLAY_2 = 6;
    public static inline var MENU_BUGS = 7;
    public static inline var MENU_PRE_BOSS = 8;
    public static inline var MENU_BOSS = 9;

    static inline var MENU_END = MENU_BOSS + 1;

    public static var hireBonus = -1;
    public static var streamerBonus = -1;
    public static var journalistBonus = -1;
    
    public static var bonusLevelOrNot = -1;
    public static var dialogueOrGameplay = -1;
    public static var lmsOrNot = -1;

    var finalHintGroup: FlxGroup;

    var skip = false;
    var blackness: FlxSprite;
    var textAnnounce: Text;

    public static function endGame()
    {
        menuId = MENU_END;
    }

    public static function reset()
    {
        CatZima.allowKeyboard = true;
        CatZima.allowGamepad = true;

        menuId = MENU_CONTROLS;

        hireBonus = -1;
        streamerBonus = -1;
        journalistBonus = -1;
        dialogueOrGameplay = -1;
        lmsOrNot = -1;
        bonusLevelOrNot = -1;
    }

	override public function create():Void
	{
		super.create();

        AchievementState.init();

        skip = false;

        var background = new FlxSprite();
        background.loadGraphic("assets/images/background.png");
        background.scrollFactor.set();
        add(background);

        player = CatZimaState.player;

        var text1 = "";
        var text2 = "";
        var text0 = "";

        //text0 = "В следующем месяце...";

        var i = CatZimaState.random.int(0, 3);
        text0 = 
            if (i == 0)
                "В следующем месяце...";
            else if (i == 1)
                "В перерыве между твитами...";
            else if (i == 2)
                "Во время E3...";
            else //if (i == 3)
                "Пока все спали...";

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
            
            case MENU_DIALOGUE_1:
                /*text1 = "Выбор 1: Строгий сюжет\n\nСледствие: Короткая лаконичная игра";
                text2 = "Выбор 2: Опциональные квесты\n\nСледствие: Полнота истории и ощущений";*/

                text1 = "Выбор 1: Побольше интриг\n\nСледствие: Плейтест с любителями интриг";
                text2 = "Выбор 2: Побольше перестрелок\n\nСледствие: Плейтест с любителями перестрелок";

            case MENU_BUGS:
                text1 = "Выбор 1: Релиз по графику, но с багами\n\nСледствие: Баги исправим потом";
                text2 = "Выбор 2: Отодвинуть релиз из-за багов\n\nСледствие: Срочно исправлять их";
            
            case MENU_BOSS:
                text1 = "Выбор 1: Последняя битва\n\nСледствие: Показать ракам, где они зимуют";
                text2 = "Выбор 2: Сдаться и пойти поспать\n\nСледствие: Сон - лучшее лекарство";

            case MENU_END:
                player.allowMove = false;

            default:
                skip = true;
        }

        var choice1: ChoiceButton;
        var choice2: ChoiceButton;

        if (menuId == MENU_BOSS)
        {
            choice1 = new ChoiceButton(text1, 0, -5, 10, 1.1/3, null, "Slot_red");
            choice2 = new ChoiceButton(text2, 0, 120, 10, 1.1/3, null, "Slot_blue");

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
            var keyHintText = new Text("Для выбора\nиспользуйте\n\n\n     или");
            keyHintText.reset(20, 60);
            //keyHintText.color = 0xff000000;
            keyHintText.color = 0xffffffff;
            keyHintText.borderSize = 1;
            keyHintText.borderColor = 0x80000000;
            keyHintText.borderStyle = OUTLINE;
            add(keyHintText);

            var keyHint1 = new FlxSprite();
            keyHint1.scrollFactor.set();
            //keyHint1.color = 0xff37b4ff;
            add(keyHint1);

            keyHint1.loadGraphic("assets/images/ui/WASD Move.png");
            keyHint1.reset(20, 90);

            var keyHint2 = new FlxSprite();
            keyHint2.scrollFactor.set();
            //keyHint2.color = 0xff37b4ff;
            add(keyHint2);

            keyHint2.loadGraphic("assets/images/ui/joypad dpad.png");
            keyHint2.reset(90, 90);
        }

        //CatZimaState.musicInter();

        blackness = new FlxSprite();
        blackness.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
        blackness.scrollFactor.set();
        add(blackness);

        textAnnounce = new Text(text0);
        textAnnounce.reset(FlxG.width / 2 - textAnnounce.width / 2, FlxG.height / 2 - textAnnounce.height / 2);
        add(textAnnounce);

        if (menuId == MENU_END)
        {
            finalHintGroup = new FlxGroup();
            //CatZimaState.musicStop();

            CatZimaState.playSound("Win.ogg", 1.0);

            add(AchievementMessage.init());

            var keyHintText = new Text("Нажмите      , чтобы поиграть в игру!");
			keyHintText.reset(15, 164);
			/*keyHintText.color = 0xff2e5b75;
			keyHintText.borderSize = 1;
			keyHintText.borderColor = 0xff37b4ff;
			keyHintText.borderStyle = OUTLINE;*/
			keyHintText.color = 0xffffffff;
			keyHintText.borderSize = 1;
			keyHintText.borderColor = 0x80000000;
			keyHintText.borderStyle = OUTLINE;
			finalHintGroup.add(keyHintText);

			var keyHint1 = new FlxSprite();
			keyHint1.scrollFactor.set();
			finalHintGroup.add(keyHint1);

			if (units.CatZima.allowKeyboard)
				keyHint1.loadGraphic("assets/images/ui/enter button.png");
			else
				keyHint1.loadGraphic("assets/images/ui/start button.png");

			keyHint1.reset(78, 164);

            add(finalHintGroup);


            var main = new Text("      Кот Зúма представляет      \n\nпри участии scorched, alexsilent, \n        HaxeFlixel, CodeMan38\n    и др. помощников");
            main.color = 0xff000000;
            main.x = 25;
            main.y = 10;
            add(main);
        }
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

        var endTimer = (player.waitMoveTimer <= 0.0);

        blackness.visible = !endTimer || skip;
        textAnnounce.visible = blackness.visible;

        if (menuId == MENU_END)
        {
            CatZimaState.musicStop();

            finalHintGroup.visible = !AchievementMessage.init().visible;

            //CatZimaState.playSound("Win.ogg", 1.0);

            if (FlxG.keys.anyJustPressed(["ENTER"]) || FlxG.gamepads.anyJustPressed(START))
            {
                CatZimaState.playSound("confirm1.wav", 1.0);
                FlxG.switchState(new StartScreenState());
                return;
            }
        }
        else
        if (!blackness.visible)
            CatZimaState.musicInter();

        if (skip && endTimer)
            choice = 0;

        if (choice >= 0)
        {
            choiceMade(choice);
        }
        
	}

    function choiceMade(choice: Int)
    {
        var noIncrement = false;
        var reset = false;

        PlayState.enemiesToSpawn = [];

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
                dialogueOrGameplay = 1;
                /*if (streamerBonus == -1)
                    BriefingState.hintId = BriefingState.HINT_STREAMER_KILL;
                else
                    BriefingState.hintId = BriefingState.HINT_STREAMER_SAVE;*/

                BriefingState.hintId = BriefingState.HINT_IDEA;

                PlayState.enemiesToSpawn = [units.Casual, units.Troll, units.Streamer, units.Casual, 
                    units.Casual, units.Troll, units.Streamer, units.Streamer, units.Casual, 
                    units.Streamer, units.Troll, units.Streamer, units.Casual];

                menuId = MENU_PRE_BOSS;
                noIncrement = true;

            case MENU_DIALOGUE_1:
                dialogueOrGameplay = 0;

                lmsOrNot = choice;

                if (choice == 0)
                {
                    PlayState.enemiesToSpawn = [units.Casual, units.Troll, units.Hardcore, units.Casual, 
                        units.Casual, units.Troll, units.Troll, units.Troll, units.Casual, 
                        units.Casual, units.Troll, units.Troll, units.Casual];
                }
                else
                {
                    PlayState.enemiesToSpawn = [units.Casual, units.Hardcore, units.Hardcore, units.Casual, 
                        units.Casual, units.Troll, units.Hardcore, units.Hardcore, units.Casual, 
                        units.Casual, units.Troll, units.Hardcore, units.Casual];
                }

                BriefingState.hintId = BriefingState.HINT_IDEA;
                
                //bonusLevelOrNot = choice;
                bonusLevelOrNot = 1;

                menuId = MENU_BUGS;
                noIncrement = true;
            
            case MENU_BUGS:
                dialogueOrGameplay = 0;

                lmsOrNot = -1;

                if (choice == 0)
                {
                    journalistBonus = 0;
                    reset = true;
                }
                else if (bonusLevelOrNot == 0)
                {
                    journalistBonus = 1;
                    reset = true;
                }
                else
                {
                    // journalistBonus = 1 too, but only after beating the level
                    PlayState.enemiesToSpawn = [ units.Bug, units.Bug, units.Bug, units.Bug, units.Bug, units.Bug ];
                }

                BriefingState.hintId = BriefingState.HINT_BUG;

                menuId = MENU_PRE_BOSS;
                noIncrement = true;

            case MENU_PRE_BOSS:
                if (dialogueOrGameplay == 1)
                {
                    if (streamerBonus == -1)
                        BriefingState.hintId = BriefingState.HINT_STREAMER_KILL;
                    else
                        BriefingState.hintId = BriefingState.HINT_STREAMER_SAVE;
                }
                else if (journalistBonus == 1)
                {
                    BriefingState.hintId = BriefingState.HINT_JOURNALIST;

                    //journalistBonus = 1;
                }
                else
                {
                    BriefingState.hintId = BriefingState.HINT_NO_JOURNALIST;
                }

            case MENU_BOSS:
                noIncrement = true;

                if (choice == 0)
                {
                    BriefingState.hintId = BriefingState.HINT_BOSS;
                    PlayState.enemiesToSpawn = [ units.Boss ];
                }
                else
                {
                    FlxG.switchState(new StartScreenState());
                    return;
                }

            default: {}
        }

        if (!noIncrement)
            ++menuId;

        if (!reset)
            FlxG.switchState(new BriefingState());
        else
            FlxG.resetState();
    }

}