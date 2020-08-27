package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;

class StartScreenState extends FlxState
{
    var start_screen: FlxSprite;

    static var introRead = false;
    public static var noMusic = false;

    var finalHintGroup: FlxGroup;

	override public function create():Void
	{
		super.create();

        AchievementState.init();

        var background = new FlxSprite();
        background.loadGraphic("assets/images/background.png");
        background.scrollFactor.set();
        add(background);

        var hint = new ChoiceButton("  Cat Jíma is a talented game developer, but not everyone likes his designs. " +
            "Attacks on the cat have increased on the Internet. \n   But, he has a secret weapon - a Twitter account. " +
            "With its help, he can defend his creative vision and bring the game to release. \n\n" +
            "  Help Jíma!", 0, 0, 10, 2.5/3, "units/sdf");
        add(hint);

        start_screen = new FlxSprite();
        start_screen.loadGraphic("assets/images/LOGO.png");
        start_screen.scrollFactor.set();
        add(start_screen);

        //FlxTween.tween(start_screen, { y: 0 }, 2, { onComplete: onCompleteLogo });

        //var startHint
        //add();

        FlxG.mouse.visible = false;

        if (noMusic)
            CatZimaState.musicStop();
        else
            CatZimaState.musicMenu();

        finalHintGroup = new FlxGroup();

		var keyHintText = new Text("To continue press            or");
        keyHintText.reset(7, 160);
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

        keyHint1.loadGraphic("assets/images/ui/enter button.png");
        keyHint1.reset(197, 161);
        //keyHint1.color = 0xff37b4ff;

        var keyHint2 = new FlxSprite();
        keyHint2.scrollFactor.set();
        finalHintGroup.add(keyHint2);

        keyHint2.loadGraphic("assets/images/ui/start button.png");
        keyHint2.reset(270, 161);
        //keyHint2.color = 0xff37b4ff;

        add(finalHintGroup);

        add(AchievementMessage.init());


        //destroySubStates = false;
        //persistentUpdate = true;
        //openSubState(exitState = new ExitState());
        add(exitState = new ExitState());
	}

    var exitState: ExitState;

	override public function update(elapsed:Float):Void
	{
        if (exitState.isOpen())
            return;

		super.update(elapsed);

        finalHintGroup.visible = !AchievementMessage.init().visible;

        if (FlxG.keys.anyJustPressed(["ENTER"]) || FlxG.gamepads.anyJustPressed(START))
		{
            CatZimaState.playSound("confirm1.wav", 1.0);

            if (!introRead)
            {
                introRead = true;
                start_screen.visible = false;
            }
            else
            {
                noMusic = false;

                ChoiceState.reset();
                FlxG.switchState(new ChoiceState());
            }
        }
	}
}
