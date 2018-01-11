package units;

class TweetBullet extends GenericBullet
{
	public function new()
	{
		super("tweetShot");

		offset.set(1, 1);
		setSize(width - 2, height - 2);
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);
    }
}