package effects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import units.GenericGuy;

class GenericEffect extends FlxSprite
{
    public var parent: GenericGuy = null;

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

        parent = null;

        animation.play("stand");
    }

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        if (parent != null)
        {
            if (parent.alive)
            {
                setPosition(parent.centerX - width / 2, parent.centerY - height / 2);
                
                flipX = parent.flipX;
            }
            else
            {
                parent = null;
            }
        }
	}

    function animationEnd(_)
    {
        kill();
    }
}