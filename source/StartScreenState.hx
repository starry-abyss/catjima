package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;

class StartScreenState extends FlxState
{
    var start_screen: FlxSprite;

    static var introRead = false;

	override public function create():Void
	{
		super.create();

        var background = new FlxSprite();
        background.loadGraphic("assets/images/background.png");
        background.scrollFactor.set();
        add(background);

        var hint = new ChoiceButton("  Кот Зúма - талантливый разработчик игр, но не всем нравятся его дизайнерские решения. " +
            "В сети Интернет участились нападения на кота. \n  Однако у него есть секретное оружие - аккаунт в Твиттере. " +
            "С его помощью он может отстоять своё креативное видение и довести игру до релиза. \n\n" +
            "  Помогите Зúме!", 0, 0, 10, 2.5/3, "units/sdf");
        add(hint);

        start_screen = new FlxSprite();
        start_screen.loadGraphic("assets/images/LOGO.png");
        start_screen.scrollFactor.set();
        add(start_screen);

        //FlxTween.tween(start_screen, { y: 0 }, 2, { onComplete: onCompleteLogo });

        //var startHint
        //add();

        FlxG.mouse.visible = false;

        CatZimaState.musicMenu();

        var keyHintText = new Text("Для продолжения нажмите:");
        keyHintText.reset(20, 160);
        keyHintText.color = 0xffffffff;
        add(keyHintText);

        var keyHint1 = new FlxSprite();
        keyHint1.scrollFactor.set();
        add(keyHint1);

        keyHint1.loadGraphic("assets/images/ui/enter button.png");
        keyHint1.reset(225, 160);

       /* var keyHint2 = new FlxSprite();
        keyHint2.scrollFactor.set();
        add(keyHint2);

        keyHint2.loadGraphic("assets/images/ui/joypad dpad.png");
        keyHint2.reset(85, 90);*/
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (FlxG.keys.anyJustPressed(["ENTER"]) || FlxG.gamepads.anyJustPressed(START))
		{
            CatZimaState.playSound("confirm1", 1.0);

            if (!introRead)
            {
                introRead = true;
                start_screen.visible = false;
            }
            else
            {
                ChoiceState.reset();
                FlxG.switchState(new ChoiceState());
            }
        }
	}
}