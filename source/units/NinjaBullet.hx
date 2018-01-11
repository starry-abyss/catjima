package units;

class NinjaBullet extends GenericBullet
{
	public function new()
	{
		super("enemyShot");

		speed = 200.0;
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);
    }
}