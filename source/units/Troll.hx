package units;

import Type;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxRandom;

class Troll extends GenericGuy
{
	var secondsToGoAway = 10.0;

	var random = new FlxRandom();

	override public function reset(x: Float, y: Float)
    {
        super.reset(x, y);

        abilityTimer = secondsToGoAway;

		var enemyListFiltered = [];
		var enemyList = PlayState.enemiesToSpawn;

		for (e in enemyList)
		{
			if (e != Troll)
				enemyListFiltered.push(e);
		}

		var graphicString = CatZima.graphicString;
		if (enemyListFiltered.length > 0)
		{
			 var enemyIndex = random.int(0, enemyListFiltered.length - 1);
			 graphicString = Reflect.field(enemyListFiltered[enemyIndex], "graphicString");

			 if (graphicString == null)
			 	graphicString = CatZima.graphicString;
		}

		setGraphic(graphicString);
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

	override public function kill()
    {
        if (alive)
            CatZimaState.playSoundRandom("troll", 1.0, 3);

        super.kill();
    }

	override public function hurt(amount: Float)
    {
        if (invincibleTimer <= 0)
		{
			abilityTimer = secondsToGoAway;

			var ignoreList: Array<FlxBasic> = [];

			CatZimaState.playSoundRandom("troll_magic", 1.0, 3);

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