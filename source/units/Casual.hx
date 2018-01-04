package units;

class Casual extends GenericGuy
{
	public function new()
	{
		super("enemy");

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
}