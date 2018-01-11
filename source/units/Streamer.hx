package units;
import flixel.FlxObject;
import flixel.FlxG;

class Streamer extends GenericGuy
{
    public static var graphicString = "streamer";

    var bullet: StreamAttack = null;

    var stopShootDuration = 4;
    var shootShift = 1;

    var speedY = 30;
    var speedYBullet = 10;

	public function new()
	{
		super(graphicString);

        speed = 50;
        overrideSpeedY = speedY;
        shootRate = 4.5;

        //bullet = ;
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        //teleportIfBullet();

        if (chasePlayerY())
        //if (standStill(25))
        {
            shootPrepare();

            //if (standStill(25))
            //    if (shootPrepare())

            if (shootTimer.elapsedTime >= shootRate - stopShootDuration && shootTimer.elapsedTime <= shootRate - stopShootDuration + shootShift)
            {
                if (bullet == null)
                {
                    bullet = cast CatZimaState.enemyBullets.recycle(units.StreamAttack);

                    // this bullet type's width is adjustable
                    bullet.width = FlxG.width;

                    //shootBullet(bullet);
                    //bullet.shootPlayer();
                    
                    // always zero velocity
                    velocity.set();

                    CatZimaState.playSoundRandom("ninja_shoot", 1.0, 3);
                }
            }
            else
            {
                killBullet();
            }

            if (bullet != null)
            {
                var offsetX = facing == FlxObject.LEFT ? frameWidth - bulletSource.x - bullet.width : bulletSource.x;
                var offsetY = /*player.facing == FlxObject.LEFT ? player.frameHeight - player.bulletSource.y :*/ bulletSource.y;

                bullet.facing = facing;

                bullet.reset(
                    x - (frameWidth - width) / 2 + offsetX /*- bullet.width / 2*/,
                    y - (frameHeight - height) / 2 + offsetY - bullet.height / 2
                    );

                overrideSpeedY = speedYBullet;
            }
            else
            {
                overrideSpeedY = speedY;
            }
        }
	}

    override public function onTouch()
    {
        //kill();
    }

    function killBullet()
    {
        if (bullet != null)
        {
            bullet.exists = false;
            bullet.alive = false;

            bullet = null;
        }
    }

    override public function kill()
    {
        killBullet();

        if (alive)
        {
            CatZimaState.playSoundRandom("ninja_die", 1.0, 3);
        }

        super.kill();
    }

}