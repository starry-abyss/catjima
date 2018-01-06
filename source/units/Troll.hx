package units;

import Type;
import flixel.FlxBasic;
import flixel.FlxSprite;

class Troll extends GenericGuy
{
	var secondsToGoAway = 10.0;

	override public function reset(x: Float, y: Float)
    {
        super.reset(x, y);

        abilityTimer = secondsToGoAway;
    }

	public function new()
	{
		super("sdf");

        speed = 150;
		health = 999999;

		abilityTimer = secondsToGoAway;
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        standStill(70);

		if (abilityTimer <= 0.0)
        {
			kill();
		}
	}

	override public function hurt(amount: Float)
    {
        if (invincibleTimer <= 0)
		{
			abilityTimer = secondsToGoAway;

			var ignoreList: Array<FlxBasic> = [];

			CatZimaState.enemies.forEachAlive(
				function (e: FlxBasic)
				{
					//if (e != this)
					if (!Std.is(e, Troll))
					{
						if (ignoreList.indexOf(e) == -1)
						{
							var enemy = cast(e, GenericGuy);

							//trace(Type.getClass(enemy));

							trace(1);

							var newEnemy: FlxSprite = cast CatZimaState.enemies.recycle(cast Type.getClass(enemy));

							newEnemy.reset(enemy.x + 40, enemy.y);

							ignoreList.push(enemy);
							ignoreList.push(newEnemy);
						}
					}
				}
			);
		}

		super.hurt(amount);
    }

    override public function onTouch()
    {
        //kill();

		//invincibleTimer = 2;
		
    }

}