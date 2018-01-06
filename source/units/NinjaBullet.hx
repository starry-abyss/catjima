package units;

class NinjaBullet extends GenericBullet
{
	public function new()
	{
		super("enemyShot");

	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);
    }
}