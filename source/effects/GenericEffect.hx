package effects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;

class GenericEffect extends FlxSprite
{
	public function new(graphic: String, width: Int, height: Int)
	{
		super();

        loadGraphic("assets/images/effects/" + graphic + ".png", true, width, height);
        updateHitbox();

        animation.finishCallback = animationEnd;

        scrollFactor.set();
	}

    override public function revive()
    {
        super.revive();

        animation.play("stand");
    }

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);
	}

    function animationEnd(_)
    {
        kill();
    }
}