package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class LogoState extends FlxState
{
    var logo_full: FlxSprite;
    var logo_outside: FlxSprite;
    var start_screen: FlxSprite;

    var startScaling = false;
    var touchGround = 2;
    var touchGroundGuard = false;

	override public function create():Void
	{
		super.create();

        logo_full = new FlxSprite();
        logo_full.loadGraphic("assets/images/GAMINATOR.png");
        logo_full.scrollFactor.set();
        add(logo_full);

        start_screen = new FlxSprite();
        start_screen.loadGraphic("assets/images/LOGO.png");
        start_screen.scrollFactor.set();
        start_screen.y = -600;
        add(start_screen);

        logo_outside = new FlxSprite();
        logo_outside.loadGraphic("assets/images/LOGO-outside.png");
        logo_outside.scrollFactor.set();
        add(logo_outside);

        FlxTween.tween(start_screen, { y: 0 }, 2, { onComplete: onCompleteLogo, ease: FlxEase.bounceOut });

        FlxG.mouse.visible = false;
	}

    function onCompleteLogo(_)
	{
        startScaling = true;
        //FlxG.camera.shake(0.01, 0.5);
        //FlxTween.tween(start_screen, { y: 0 }, 1, { onComplete: function (_) {  } );
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        //trace(start_screen.y);

        if (touchGround > 0)
        {
            if (!touchGroundGuard)
            {
                if (start_screen.y > -10)
                {
                    touchGroundGuard = true;

                    FlxG.camera.shake(0.005 * touchGround, 0.5);

                    touchGround--;
                    //FlxG.camera.stopFX();

                    //trace("A");
                }
            }
            else
            {
                if (start_screen.y < -20)
                {
                    touchGroundGuard = false;

                    //trace("B");
                }
            }
        }

        if (startScaling)
        {
            var scale = logo_outside.scale.x + 5 * elapsed;
            logo_outside.x -= 70 * elapsed;
            logo_outside.scale.set(scale, scale);

            if (logo_outside.scale.x > 10)
            {
                FlxG.switchState(new StartScreenState());
            }
        }
	}
}