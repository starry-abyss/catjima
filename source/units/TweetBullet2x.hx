package units;

class TweetBullet2x extends GenericBullet
{
	public function new()
	{
		super("tweetShot2x");

		//offset.set(1, 1);
		//setSize(width - 2, height - 2);

		offset.set(4, 4);
		setSize(9, 10);
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);
    }
}