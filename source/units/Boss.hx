package units;

import flixel.FlxObject;
import flixel.FlxSprite;

class Boss extends GenericGuy
{
    public static var graphicString = "boss";

    var phase = 0;

    var bombRate = 3.0;

	public function new()
	{
		super(graphicString);

        overrideSpeedY = 75;
        shootRate = 0.5;

        bulletSource.x += 4;

        health = 12;

        //var vulnerableAnimation = [0, 2, 3, 1];

        //animation.add("stand2", vulnerableAnimation, 2, true);
        //animation.add("move2", vulnerableAnimation, 2, true);
        //animation.add("stand2", [2, 3], 2, true);
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        if (phase == 0)
        {
            //if (standStill(25))
            if (phase != 0 || chasePlayerY())
            {
                phase = 1;

                flee();
                shootBullets();

                /*CatZimaState.enemyBullets.forEachAlive(
                    function (pBullet)
                    {
                        var playerBullet: GenericBullet = cast pBullet;
                        if (distance(CatZimaState.player, playerBullet) <= 150)
                        {
                            //trace(playerBullet.velocity.x);

                            if (Math.abs(playerBullet.velocity.x) >= 150)
                                playerBullet.velocity.x /= 3;
                        }
                    }
                );*/

                shootPlayer();
            }
        }
        else if (phase == 1)
        {
            if (standStill(70))
            {
                flee();

                if (abilityTimer <= 0.0)
                {
                    abilityTimer = bombRate;
                    generateUnit(units.Bomb, CatZimaState.player, true, CatZimaState.playerBullets);
                }
                else if (abilityTimer <= 2.0)
                {
                    shootBullets();
                    shootPlayer();
                }

                
            }
        }
        else if (phase == 2)
        {
            if (standStill(25))
            {
  
            }
        }

        
	}

    function flee()
    {
        if (distance(CatZimaState.player, this) <= 75)
            teleport();
    }

    function shootBullets()
    {
        CatZimaState.playerBullets.forEachAlive(
            function (pBullet)
            {
                var playerBullet: GenericBullet = cast pBullet;
                if (distance(this, playerBullet) <= 150)
                {
                    //trace(playerBullet.velocity.x);

                    if (Math.abs(playerBullet.velocity.x) >= 200)
                        playerBullet.velocity.x /= 3;

                    var missRate = 2.0;

                    var gonnaHit = Math.abs(centerY - playerBullet.centerY) < playerBullet.height + missRate * (height / 2);

                    if (gonnaHit && shootPrepare())
                    {
                        var bullet = prepareBullet();
                        bullet.shootInDirection(playerBullet);

                        //CatZimaState.playSoundRandom("ninja_shoot", 1.0, 3);

                    }
                }
            }
        );
    }

    function shootPlayer()
    {
        if (shootPrepare())
        {
            var bullet = prepareBullet();

            bullet.shootPlayer();

            //CatZimaState.playSoundRandom("ninja_shoot", 1.0, 3);

        }
    }

    function prepareBullet(): units.NinjaBullet
    {
        var bullet: units.NinjaBullet = cast CatZimaState.enemyBullets.recycle(units.NinjaBullet);

        var offsetX = facing == FlxObject.LEFT ? frameWidth - bulletSource.x : bulletSource.x;
        var offsetY = /*player.facing == FlxObject.LEFT ? player.frameHeight - player.bulletSource.y :*/ bulletSource.y;

        bullet.reset(
            x - (frameWidth - width) / 2 + offsetX - bullet.width / 2,
            y - (frameHeight - height) / 2 + offsetY - bullet.height / 2
            );
        
        return bullet;
    }

    override public function hurt(amount: Float)
    {
        //phase++;

        if (phase == 2)
            phase = 0;
        
        super.hurt(amount);
    }

    override public function onTouch()
    {
        //kill();
    }

    override public function revive()
    {
        super.revive();

        phase = 0;
        shootRate = CatZimaState.player.shootRate;
    }

    override public function kill()
    {
        super.kill();
    }

}