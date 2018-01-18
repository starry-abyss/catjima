package units;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;

class HealthPack extends GenericGuy
{
    public static var graphicString = "health";

    //var random = new FlxRandom();

	public function new()
	{
		super(graphicString);

        speed = 0;

        setSize(16, 16);
        offset.set(18, 18);

        animation.stop();
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

	}

    override public function revive()
    {
        super.revive();

    }

    override public function onTouch()
    {
        //kill();
    }

    override public function kill()
    {
        super.kill();
    }

}