package units;

import flixel.FlxObject;

class Casual extends GenericGuy
{
    public static var graphicString = "blonde";

	public function new()
	{
		super(graphicString);

        speed = 50;

        //allowCollisions = FlxObject.NONE;
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        chasePlayer();
	}

    override public function onTouch()
    {
        

        kill();
    }

    override public function kill()
    {
        if (alive)
            CatZimaState.playSoundRandom("kiss", 0.8, 3);

        super.kill();
    }

}