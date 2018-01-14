package units;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxRandom;

class Bug extends GenericGuy
{
    public static var graphicString = "bug";

    var random = new FlxRandom();

	public function new()
	{
		super(graphicString);

        speed = 20;

        setSize(30, 30);
        offset.set(10, 10);
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        if (x > FlxG.width)
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
            CatZimaState.playSoundRandom("ninja_die", 1.0, 3);

        super.kill();
    }

}