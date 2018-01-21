package units;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;

class Bug extends GenericGuy
{
    public static var graphicString = "bug";

    var random = new FlxRandom();

    //var yBase: Float;

	public function new()
	{
		super(graphicString);

        speed = 70;

        setSize(30, 30);
        offset.set(10, 10);
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        if (x > FlxG.width && !isOnScreen())
        {
            x = -width;
            last.x = x;
        }
	}

    override public function revive()
    {
        super.revive();

        velocity.set(random.float(speed / 2, speed), 0.0);
    }

    override public function onTouch()
    {
        //kill();
    }

    override public function kill()
    {
        if (alive)
             CatZimaState.playSoundRandom("bug", 0.8, 3);

        super.kill();
    }

}