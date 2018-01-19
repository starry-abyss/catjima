package units;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;

class Bomb extends GenericGuy
{
    public static var graphicString = "bug";

    var boomRadius = 50;

	public function new()
	{
		super(graphicString);

        speed = 0;

        setSize(30, 30);
        offset.set(10, 10);
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

	}

    override public function revive()
    {
        super.revive();

    }

    override public function onTouch()
    {
        //kill();
    }

    function tryHurt(sprite: FlxSprite)
    {
        if (distance(this, sprite) <= boomRadius)
        {
            sprite.hurt(1);
        }
    }

    override public function kill()
    {
        /*if (alive)
            CatZimaState.playSoundRandom("ninja_die", 1.0, 3);*/

        super.kill();

        tryHurt(CatZimaState.player);

        CatZimaState.playerBullets.forEachAlive(
            function (basic)
            {
                tryHurt(cast basic);
            }
        );

        CatZimaState.enemies.forEachAlive(
            function (basic)
            {
                tryHurt(cast basic);
            }
        );

        CatZimaState.enemyBullets.forEachAlive(
            function (basic)
            {
                tryHurt(cast basic);
            }
        );

    }

}