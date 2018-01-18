package units;

import flixel.FlxObject;
import flixel.FlxSprite;

class Boss extends GenericGuy
{
    public static var graphicString = "boss";

    var phase = 0;

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

    function distance(s1: FlxSprite, s2: FlxSprite): Float
    {
        var dx = (s1.x + s1.width / 2) - (s2.x + s2.width / 2);
        var dy  = (s1.y + s1.height / 2) - (s2.y + s2.height / 2);

        return Math.sqrt(dx*dx + dy*dy);
    }

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        if (phase == 0)
        {
            //if (standStill(25))
            if (chasePlayerY())
            {
                if (distance(CatZimaState.player, this) <= 75)
                    teleport();

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

                if (shootPrepare())
                {
                    var bullet = prepareBullet();

                    bullet.shootPlayer();

                    //CatZimaState.playSoundRandom("ninja_shoot", 1.0, 3);

                }
            }
        }
        else if (phase == 1)
        {
            //;
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