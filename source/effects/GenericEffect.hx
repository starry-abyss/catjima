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
    public var offsetX: Float = 0.0;
    public var offsetY: Float = 0.0;

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
                flipX = parent.flipX;

                var offsetXApplied = flipX ? -offsetX : offsetX;

                setPosition(parent.centerX - width / 2 + offsetXApplied, parent.centerY - height / 2 + offsetY);
            }
            else
            {
                parent = null;

                kill();
            }
        }
	}

    function animationEnd(_)
    {
        kill();
    }
}