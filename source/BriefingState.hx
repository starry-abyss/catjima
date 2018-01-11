package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class BriefingState extends CatZimaState
{
    var player: units.CatZima;
    var choices: Array<ChoiceButton>;

    var startButton: ChoiceButton;

    public static var hintId = HINT_HARDCORE;

    public static inline var HINT_BLONDE = 0;
    public static inline var HINT_HARDCORE = 1;
    public static inline var HINT_TROLL = 2;
    public static inline var HINT_BUG = 3;
    public static inline var HINT_STREAMER = 4;
    public static inline var HINT_STREAMER_SAVE = 5;
    public static inline var HINT_STREAMER_KILL = 6;
    public static inline var HINT_JOURNALIST = 7;
    public static inline var HINT_BOSS = 7;

	override public function create():Void
	{
		super.create();

        var background = new FlxSprite();
        background.loadGraphic("assets/images/background.png");
        background.scrollFactor.set();
        add(background);

        var hint: ChoiceButton = null;

        switch (hintId)
        {
            case HINT_BLONDE:
                hint = new ChoiceButton("Недоволен выбором: Казуальный игрок\n\nНе будет игры на мобилку - затапает!", 0, 0, 10, 4/9, "units/blonde");

            case HINT_HARDCORE:
                hint = new ChoiceButton("Недоволен выбором: Хардкорный игрок\n\nСросся с контроллером. Реакция - как у ниндзи!", 0, 0, 10, 4/9, "units/hardcore");

            case HINT_TROLL:
                hint = new ChoiceButton("Недоволен по жизни: Анонимный тролль\n\nИзбегать ЛЮБОГО контакта! Влияет на окружающих.", 0, 0, 10, 4/9, "units/trololoshka");

            case HINT_BUG:
                hint = new ChoiceButton("Недоволен выбором: Баг после апдейта\n\nВнедрён агентом Смитом. Позовите программистов!", 0, 0, 10, 4/9, "units/bug");

            case HINT_STREAMER:
                hint = new ChoiceButton("Недоволен выбором: Стример\n\nСчитает, что его зрителям не понравится это изменение.", 0, 0, 10, 4/9, "units/streamer");

            case HINT_STREAMER_SAVE:
                hint = new ChoiceButton("Спасенный стример понял, что был не прав, отблагодарил, что вы с ним мягко обошлись, и обещал помочь вам в будущем.", 0, 0, 10, 4/9, null);
            
            case HINT_STREAMER_KILL:
                hint = new ChoiceButton("После грубых разборок стримеры сильно обижены. Но зато на Гамине написали обзор вашей игры и сравнили её с Dark Souls.", 0, 0, 10, 4/9, null);
            
            case HINT_JOURNALIST:
                hint = new ChoiceButton("Журналисты благодарят вас, что баги исправлены, и просят друзей в Твиттере увеличить длину сообщений в 2 раза.", 0, 0, 10, 4/9, null);

            case HINT_BOSS:
                hint = new ChoiceButton("Недоволен, что вы ещё живы: агент Смит.\n\nЭто точно его происки! Он искажает сознание пользователей!", 0, 0, 10, 4/9, null);

            default: {}
        }

        
        //var choice2 = new ChoiceButton("Выбор 2: Управление геймпадом", 0, 120, 10);
        choices = [ hint ];

        player = CatZimaState.player;

        startButton = new ChoiceButton("Blog", Math.floor(FlxG.width * 3 / 4 - 50), Math.floor(FlxG.height * 3 / 4 - 50), 10, 1/3);

        player.reset(Math.floor(FlxG.width * 1 / 4 - player.width / 2), Math.floor(FlxG.height * 3 / 4 - player.height / 2 - 20));
		
        for (c in choices)
        {
            add(c);
        }

        add(startButton);

        add(player);
        add(CatZimaState.playerBullets);

        player.allowMove = false;

        bgColor = 0;
        
        
        if (hintId == HINT_BLONDE)
        {
            var keyHintText = new Text("Нажмите         для отправки твита");
            keyHintText.reset(20, 160);
            keyHintText.color = 0xff000000;
            add(keyHintText);

            var keyHint = new FlxSprite();
            keyHint.scrollFactor.set();
            add(keyHint);

            if (units.CatZima.allowKeyboard)
            {
                keyHint.loadGraphic("assets/images/ui/Space Button.png");
                keyHint.reset(95, 160);
            }
            else
            {
                keyHint.loadGraphic("assets/images/ui/Button A.png");
                keyHint.reset(105, 155);
            }
        }
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (startButton.overlaps(CatZimaState.playerBullets))
        {
            FlxG.switchState(new PlayState());
        }
        
	}

}