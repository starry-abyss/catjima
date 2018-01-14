package units;
import flixel.FlxObject;

class Boss extends GenericGuy
{
    public static var graphicString = "boss";

	public function new()
	{
		super(graphicString);

        overrideSpeedY = 75;
        shootRate = 3;

        var vulnerableAnimation = [0, 2, 3, 1];

        animation.add("stand2", vulnerableAnimation, 2, true);
        animation.add("move2", vulnerableAnimation, 2, true);
        //animation.add("stand2", [2, 3], 2, true);
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

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