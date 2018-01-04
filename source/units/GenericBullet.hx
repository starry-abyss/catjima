package units;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;

class GenericBullet extends FlxSprite
{
    var speed = 300.0;

	public function new(graphic: String)
	{
		super();

        loadGraphic("assets/images/units/" + graphic + ".png", false);
        //updateHitbox();
        //setSize(20, 30);

        //centerOffsets();
        updateHitbox();

        //animation.add("stand", [0, 1], 3, true);
        //animation.play("stand");

        scrollFactor.set();

        //setFacingFlip(FlxObject.LEFT, true, false);
        //setFacingFlip(FlxObject.RIGHT, false, false);
	}

    override public function kill()
    {
        if (isOnScreen())
        {
            CatZimaState.spawnEffect(effects.TweetBoom, x + width / 2, y + height / 2);
        }

        super.kill();

        //exists = true;
    }

    /*override public function revive()
    {
        super.revive();
    }*/

    public function shoot()
    {
        velocity.set(((facing == FlxObject.LEFT) ? -1 : 1) * speed, 0);
    }

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        if (!isOnScreen())
        {
            //alive = false;
            //exists = false;
            kill();
        }
	}
}
