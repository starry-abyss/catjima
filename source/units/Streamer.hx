package units;
import flixel.FlxObject;
import flixel.FlxG;

class Streamer extends GenericGuy
{
    public static var graphicString = "streamer";

    var bullet: StreamAttack = null;
    //var effectPrepare: effects.StreamPrepare = null;

    var effectPrepare = false;

    var stopShootDuration = 2;
    var shootShift = 0.5;

    var speedY = 30;
    var speedYBullet = 10;

	public function new()
	{
		super(graphicString);

        speed = 50;
        overrideSpeedY = speedY;
        shootRate = 2.5;

        //bullet = ;
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        //teleportIfBullet();

        if (!alive)
        {
            if (isOnScreen())
                goAway();
            else
                exists = false;
        }
        else
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

    function killBullet()
    {
        if (bullet != null)
        {
            bullet.exists = false;
            bullet.alive = false;

            bullet = null;
        }

        /*if (effectPrepare != null)
        {
            effectPrepare.exists = false;
            effectPrepare.alive = false;

            effectPrepare = null;
        }*/
    }

    public function softKill()
    {
        if (alive)
        {
            alive = false;

            if (ChoiceState.streamerBonus == -1)
                ChoiceState.streamerBonus = 0;

            ChoiceState.streamerBonus++;

            //kill();

            killBullet();

            allowCollisions = FlxObject.NONE;
        }
    }

    override public function revive()
    {
        super.revive();

        allowCollisions = FlxObject.ANY;
        effectPrepare = false;
    }

    override public function kill()
    {
        killBullet();

        if (alive)
        {
            CatZimaState.playSoundRandom("streamer_die", 1.0, 3);
        }

        super.kill();
    }

}