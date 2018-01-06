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

	override public function create():Void
	{
		super.create();

        var hint: ChoiceButton = null;

        switch (hintId)
        {
            case HINT_BLONDE:
                hint = new ChoiceButton("Знакомьтесь: Казуальный игрок\n\nНе будет игры на мобилку - затапает!", 0, 0, 10, 4/9, "units/blonde");

            case HINT_HARDCORE:
                hint = new ChoiceButton("Знакомьтесь: Хардкорный игрок\n\nСросся с контроллером. Реакция - как у ниндзи!", 0, 0, 10, 4/9, "units/hardcore");

            case HINT_TROLL:
                hint = new ChoiceButton("Знакомьтесь: Анонимный тролль\n\nИзбегать любого контакта! Сам уйдёт.", 0, 0, 10, 4/9, null);

            case HINT_BUG:
                hint = new ChoiceButton("Знакомьтесь: Баг после апдейта\n\nПосмотрим правде в глаза - на них не действуют твиты.", 0, 0, 10, 4/9, null);

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