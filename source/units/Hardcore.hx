package units;
import flixel.FlxObject;

class Hardcore extends GenericGuy
{
    public static var graphicString = "hardcore";

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

        animationSuffix = (abilityTimer <= 0.0) ? "" : "2";

        teleportIfBullet();

        if (standStill(25))
            if (shootPrepare())
			{
                var bullet: units.NinjaBullet = cast CatZimaState.enemyBullets.recycle(units.NinjaBullet);

                var offsetX = facing == FlxObject.LEFT ? frameWidth - bulletSource.x : bulletSource.x;
                var offsetY = /*player.facing == FlxObject.LEFT ? player.frameHeight - player.bulletSource.y :*/ bulletSource.y;

                bullet.reset(
                    x - (frameWidth - width) / 2 + offsetX - bullet.width / 2,
                    y - (frameHeight - height) / 2 + offsetY - bullet.height / 2
                    );
                //bullet.facing = player.facing;

                //shootBullet(bullet);
                bullet.shootPlayer();

                CatZimaState.playSoundRandom("ninja_shoot", 1.0, 3);
            }
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