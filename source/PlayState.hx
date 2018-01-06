package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import units.GenericGuy;

typedef Backdrop = FlxBackdrop;
//typedef Backdrop = FlxSprite;

class PlayState extends CatZimaState
{
	var backgrounds = new FlxGroup();
	var foregrounds = new FlxGroup();

	var player: units.CatZima;

	var spawnTimer: FlxTimer;

	var random = new FlxRandom();

	var playerHealth: FlxTilemap;

	static public var enemiesToSpawn: Array<Class<FlxBasic>> = [];

	function backgroundByIndex(index: Int): Backdrop
	{
		return cast backgrounds.members[index];
	}

	function foregroundByIndex(index: Int = 0): Backdrop
	{
		return cast foregrounds.members[index];
	}

	override public function create(): Void
	{
		super.create();

		spawnTimer = new FlxTimer(CatZimaState.timerManager);
		
		player = CatZimaState.player;

		backgrounds.add(new Backdrop("assets/images/background.png"));
		backgrounds.add(new Backdrop("assets/images/plane4.png"));
		backgrounds.add(new Backdrop("assets/images/plane3.png"));

		foregrounds.add(new Backdrop("assets/images/plane2.png"));
		foregrounds.add(new Backdrop("assets/images/plane1.png"));

		backgroundByIndex(0).scrollFactor.set(0.1, 0);
		backgroundByIndex(1).scrollFactor.set(0.2, 0);
		backgroundByIndex(2).scrollFactor.set(0.25, 0);

		foregroundByIndex(0).scrollFactor.set(2.5, 0);
		foregroundByIndex(1).scrollFactor.set(0.5, 0);

		//FlxG.stage.color = foregroundByIndex(1).pixels.getPixel(0, 0);
		

		add(backgrounds);

		add(CatZimaState.enemies);

		//player = new units.CatZima();
		//player.reset(50, 50);
		add(player);
		

		add(CatZimaState.enemyBullets);
		add(CatZimaState.playerBullets);

		add(CatZimaState.effects);

		//FlxG.worldBounds

		add(foregrounds);

		spawnTimer.start(2, spawnEnemy, 0);

		FlxG.camera.scroll.x = 0;


		playerHealth = new FlxTilemap();
		playerHealth.loadMapFromArray([1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 10, 1, "assets/images/ui/HUD HPHero.png", 23, 16, null, 1);
		playerHealth.scrollFactor.set();
		playerHealth.setPosition(2, 2);
		add(playerHealth);
	}

	function spawnEnemy(_)
	{
		if (enemiesToSpawn.length > 0)
		{
			var enemyType = enemiesToSpawn.pop();
			var enemy: FlxSprite = cast CatZimaState.enemies.recycle(enemyType);

			var side = random.int(0, 1);
			var x = (side == 0) ? -enemy.width : FlxG.width;
			var y = random.int(0, Math.floor(FlxG.height / 2)) + FlxG.height / 4;

        	enemy.reset(x - enemy.width / 2, y - enemy.height / 2);
		}
		else
		{
			if (CatZimaState.enemies.countLiving() <= 0)
			{
				spawnTimer.cancel();
				winTheLevel();
			}
		}

		if (!player.alive)
		{
			CatZimaState.restartGame = true;
			//FlxG.switchState(new AchievementState());
		}
	}

	function winTheLevel()
	{
		trace("won");

		FlxG.switchState(new ChoiceState());
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

		FlxG.camera.scroll.x += elapsed * 30;

		var hp = Math.ceil(player.health);
		for (i in 0...playerHealth.widthInTiles)
			playerHealth.setTile(i, 0, i >= hp ? 0 : 1, true);

		/*if (CatZimaState.enemies.countLiving() <= 0)
		{
			//trace("won");
		}*/
	}
}