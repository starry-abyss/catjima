package units;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;

class GenericBullet extends FlxSprite
{
    var speed = 300.0;

    public var centerX(get, never): Float;
    public var centerY(get, never): Float;

	public function new(graphic: String, animated: Bool = false, width: Int = null, height: Int = null)
	{
		super();

        loadGraphic("assets/images/units/" + graphic + ".png", animated, width, height);
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

    public function shootInDirection(target: FlxSprite)
    {
        var v = FlxVector.get(Math.round(target.x + target.width / 2 - centerX), Math.round(target.y + target.height / 2 - centerY));
        var length = v.length;
        if (length != 0.0)
            v.set(v.x / length, v.y / length);

        //var oldVelocityX = velocity.x;

        velocity.set(v.x * speed, v.y * speed);
    }

    public function shootPlayer()
    {
        shootInDirection(CatZimaState.player);
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

    function get_centerX(): Float
    {
        return x + width / 2;
    }

    function get_centerY(): Float
    {
        return y + height / 2;
    }
}
