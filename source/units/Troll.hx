package units;

import Type;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.math.FlxRandom;

class Troll extends GenericGuy
{
	var secondsToGoAway = 7.0;
	var spawnLimit = 10;

	var random = new FlxRandom();

	var type: Class<GenericGuy>;

	override public function reset(x: Float, y: Float)
    {
        super.reset(x, y);

		type = null;

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
			 type = cast enemyListFiltered[enemyIndex];
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

		//allowCollisions = FlxObject.NONE;
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        standStill(70);

		visible = (invincibleTimer <= 0.0);

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
        //if (invincibleTimer <= 0)
		{
			abilityTimer = secondsToGoAway;

			var ignoreList: Array<FlxBasic> = [];

			CatZimaState.playSoundRandom("troll_magic", 1.0, 3);

			CatZimaState.enemies.forEachAlive(
				function (e: FlxBasic)
				{
					var enemy = cast(e, GenericGuy);

					if (ignoreList.length >= 2 * spawnLimit)
						return;

					//if (e != this)
					if (!Std.is(e, Troll) && enemy.isOnScreen())
					{
						if (ignoreList.indexOf(e) == -1)
						{

							//trace(Type.getClass(enemy));

							//trace(1);

							//var newEnemy: FlxSprite = cast CatZimaState.enemies.recycle(cast Type.getClass(enemy));
							//newEnemy.reset(enemy.x + 40, enemy.y);

							var newEnemy = generateUnit(Type.getClass(enemy), enemy);

							//CatZimaState.spawnEffect(effects.TrollCast, newEnemy.centerX, newEnemy.centerY);

							ignoreList.push(enemy);
							ignoreList.push(newEnemy);
						}
					}
				}
			);

			if (ignoreList.length == 0)
				generateUnit(type, CatZimaState.player);

			//CatZimaState.spawnEffect(effects.TrollCast, centerX, centerY);
			if (invincibleTimer <= 0)
				//CatZimaState.spawnEffect(effects.TrollFace, centerX, centerY, this);
				CatZimaState.spawnEffect(effects.TrollFace, 0, 0, this);

			CatZimaState.unlockAchievement("hehe");
		}

		super.hurt(amount);
    }

	function generateUnit(unitType: Class<GenericGuy>, unitNearby: GenericGuy): GenericGuy
	{
		var newEnemy: GenericGuy = cast CatZimaState.enemies.recycle(cast unitType);
		var distance = 1.0;
		var offset = unitNearby.facing == FlxObject.LEFT ? unitNearby.width + unitNearby.width * distance : -distance * unitNearby.width - newEnemy.width;

		newEnemy.reset(unitNearby.x + offset, unitNearby.y);
		newEnemy.facing = unitNearby.facing;

		CatZimaState.spawnEffect(effects.TrollCast, newEnemy.centerX, newEnemy.centerY);

		return cast newEnemy;
	}

    override public function onTouch()
    {
        //kill();

		//invincibleTimer = 2;
		
    }

}