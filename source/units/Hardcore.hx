package units;
import flixel.FlxObject;

class Hardcore extends GenericGuy
{

	public function new()
	{
		super("hardcore");

        speed = 75;
        shootRate = 3;
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

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
            }
	}

    override public function onTouch()
    {
        //kill();
    }

}