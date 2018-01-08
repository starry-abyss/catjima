package units;

class Casual extends GenericGuy
{
    public static var graphicString = "blonde";

	public function new()
	{
		super(graphicString);

        speed = 50;
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
            CatZimaState.playSoundRandom("kiss", 1.0, 3);

        super.kill();
    }

}