package units;
import flixel.FlxObject;
import flixel.FlxG;

class RobotStreamer extends Streamer
{
    public static var graphicString = "streamer";

	public function new()
	{
		super(graphicString);

        /*speed = 50;
        overrideSpeedY = speedY;
        shootRate = 2.5;*/

	}

    override function streamerLogic()
    {
        if (chasePlayerY())
        //if (standStill(25))
        {
            shootPrepare();

            //if (standStill(25))
            //    if (shootPrepare())



            if (shootTimer.elapsedTime <= shootRate - stopShootDuration)
            {
                if (!effectPrepare)
                {
                    //var offsetX = facing == FlxObject.LEFT ? frameWidth - bulletSource.x : bulletSource.x;

                    //if (effectPrepare == null)
                    //{
                    CatZimaState.spawnEffect(effects.StreamPrepare, 20, 0, this);

                    effectPrepare = true;

                    CatZimaState.playSoundRandom("stream_prepare", 0.6, 3);
                    //}
                }
            }
            else if (shootTimer.elapsedTime >= shootRate - stopShootDuration && shootTimer.elapsedTime <= shootRate - stopShootDuration + shootShift)
            {
                if (bullet == null)
                {
                    bullet = cast CatZimaState.enemyBullets.recycle(units.StreamAttack);

                    // this bullet type's width is adjustable
                    bullet.width = FlxG.width;
                    //bullet.offset.set(-0.5 * (bullet.width - bullet.frameWidth), -0.5 * (bullet.height - bullet.frameHeight));
                    //bullet.centerOrigin();

                    //shootBullet(bullet);
                    //bullet.shootPlayer();
                    
                    // always zero velocity
                    velocity.set();

                    CatZimaState.playSoundChunkRandom("streamer_beam", 0.6, shootRate - stopShootDuration);
                }
            }
            else
            {
                killBullet();
                effectPrepare = false;
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

    override public function softKill()
    {
        // do nothing
    }

    override public function revive()
    {
        super.revive();

    }

    override public function kill()
    {
        super.kill();

    }

}