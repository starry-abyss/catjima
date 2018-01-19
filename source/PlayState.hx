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

	var programmers = new FlxGroup();
	var blogs = new FlxGroup();
	var commits = new FlxGroup();
	
	var healthPacks = new FlxGroup();

	var player: units.CatZima;

	var spawnTimer: FlxTimer;

	var random = new FlxRandom();

	var playerHealth: FlxTilemap;
	var bossHealth: FlxTilemap;

	var bossLevel = false;
	var bugLevel = false;

	var boss: units.Boss = null;

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

		persistentUpdate = true;

		spawnTimer = new FlxTimer(CatZimaState.timerManager);
		
		player = CatZimaState.player;

		var logo_full = new FlxSprite();
        logo_full.loadGraphic("assets/images/GAMINATOR.png");
        logo_full.scrollFactor.set();
        add(logo_full);

		backgrounds.add(new Backdrop("assets/images/background.png", 1, 1, true, false));
		backgrounds.add(new Backdrop("assets/images/plane4.png", 1, 1, true, false));
		backgrounds.add(new Backdrop("assets/images/plane3.png", 1, 1, true, false));

		foregrounds.add(new Backdrop("assets/images/plane2.png"));
		foregrounds.add(new Backdrop("assets/images/plane1.png"));

		backgroundByIndex(0).scrollFactor.set(0.1, 0);
		backgroundByIndex(1).scrollFactor.set(0.2, 0);
		backgroundByIndex(2).scrollFactor.set(0.25, 0);

		foregroundByIndex(0).scrollFactor.set(2.5, 0);
		foregroundByIndex(1).scrollFactor.set(0.5, 0);

		//FlxG.stage.color = foregroundByIndex(1).pixels.getPixel(0, 0);
		

		add(backgrounds);

		add(commits);

		add(healthPacks);

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
		playerHealth.loadMapFromArray([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 12, 1, "assets/images/ui/HUD HPHero.png", 23, 16, null, 1);
		playerHealth.scrollFactor.set();
		playerHealth.setPosition(2, 2);
		add(playerHealth);


		bossHealth = new FlxTilemap();
		bossHealth.loadMapFromArray([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 12, 1, "assets/images/ui/HUD HP Boss.png", 23, 16, null, 1);
		bossHealth.scrollFactor.set();
		bossHealth.setPosition(2, FlxG.height - 18);
		add(bossHealth);

		
		if (PlayState.enemiesToSpawn.length == 0)
		{
			winTheLevel();
			//return;
		}
		else
		{
			if (PlayState.enemiesToSpawn[0] == units.Bug)
			{
				bugLevel = true;
				ChoiceState.journalistBonus = 1;

				var names = [ "@apg_rt", "@2ebacbac", "@ultraCodz" ];

				for (i in 0...3)
				{
					var programmer = new ChoiceButton(names[i], 2 + 89 * i, 137, 10, 1/3.7, null, "Slot_blue", 1/2.3);
					//programmer.width = 100;
					//programmer

					programmers.add(programmer);


					var blog = new FlxSprite(60 + 89 * i, 130);
					blog.loadGraphic("assets/images/ui/blog.png", false);
					blog.updateHitbox();

					blog.scrollFactor.set();

					blogs.add(blog);
				}

				add(programmers);
				add(blogs);

				addCommitMessage("Вот оно что!");
				addCommitMessage("Это - фича", true);
				addCommitMessage("вроде так.");
				addCommitMessage("достал кот");
				addCommitMessage("попытка 2");
				addCommitMessage("Завтра в отпуск");
				addCommitMessage("Забыл умножить");
				//addCommitMessage("со stack overflow");
			}
			else if (PlayState.enemiesToSpawn[0] == units.Boss)
			{
				bossLevel = true;
			}
		}

		if (bossLevel)
		{
			var healthPacksTotal = ChoiceState.journalistBonus;
			if (healthPacksTotal > 5)
				healthPacksTotal = 5;
			
			//var healthPacksTotal = 5;

			if (healthPacksTotal > 0)
			{
				for (i in 0...healthPacksTotal)
				{
					var hp: units.HealthPack = cast healthPacks.recycle(units.HealthPack);

					var x = random.float(FlxG.width / 4, FlxG.width * 3 / 4);
					var y = random.float(FlxG.height / 4, FlxG.height * 3 / 4);

					hp.reset(x - hp.width / 2, y - hp.height / 2);
				}
			}
		}
		else
		{
			var keyHintText = new Text("Пауза/значки");
			keyHintText.reset(175, 4);
			/*keyHintText.color = 0xff2e5b75;
			keyHintText.borderSize = 1;
			keyHintText.borderColor = 0xff37b4ff;
			keyHintText.borderStyle = OUTLINE;*/
			keyHintText.color = 0xffffffff;
			keyHintText.borderSize = 1;
			keyHintText.borderColor = 0x80000000;
			keyHintText.borderStyle = OUTLINE;
			add(keyHintText);

			var keyHint1 = new FlxSprite();
			keyHint1.scrollFactor.set();
			add(keyHint1);

			if (units.CatZima.allowKeyboard)
				keyHint1.loadGraphic("assets/images/ui/enter button.png");
			else
				keyHint1.loadGraphic("assets/images/ui/start button.png");

			keyHint1.reset(278, 4);
			//keyHint1.color = 0xff37b4ff;
		}

		// for both tweet upgrades
		if (ChoiceState.hireBonus == 0 && ChoiceState.journalistBonus == 1)
			CatZimaState.unlockAchievement("message");
		
		add(AchievementMessage.init());
		//AchievementMessage.showMessage("test!");
	}

	function addCommitMessage(text: String, goodFix: Bool = false)
	{
		var commit = new ChoiceButton("git commit -m \n\"" + text + "\"", 0, 0, 10, 1/2.4, null, goodFix ? "Slot_red" : "Slot_blue", 1/2.7);

		if (!goodFix)
			commit.disableCollision();
		commit.speed = 50;
		commit.kill();

		commits.add(commit);
	}

	function callProgrammer(bullet, programmerBlog)
	{
		bullet.kill();

		programmerBlog.kill();
		var timer = new FlxTimer(CatZimaState.timerManager);
		timer.start(1.5, function (_) programmerBlog.revive(), 1);

		if (commits.countDead() > 0)
		{
			var commit: ChoiceButton = cast commits.recycle();
			commit.moveTo(programmerBlog.x - 50, programmerBlog.y);
			commit.time = 0.0;
		}
	}

	function smashBug(bug: FlxBasic, commit: FlxBasic)
	{
		/*trace(Type.typeof(bug));
		trace(Type.typeof(commit));

		if (cast(commit, ChoiceButton).alpha < 0.2)
			//return false;
			return;*/

		var oops: FlxSprite = cast backgrounds.getFirstAlive();
		if (oops != null)
		{
			oops.alive = false;
			oops.velocity.y = 50;

			FlxG.camera.shake(0.005, 0.5);
		}

		bug.kill();
		commit.kill();

		//return true;
	}

	function healthPackPickup(p, hp)
	{
		hp.kill();

		player.hurt(-1);
	}

	function spawnEnemy(_)
	{
		if (!player.alive)
		{
			loseTheLevel();
		}
		else
		{

			if (enemiesToSpawn.length > 0)
			{
				var enemyType = enemiesToSpawn.pop();
				var enemy: FlxSprite = cast CatZimaState.enemies.recycle(enemyType);

				var side = random.int(0, 1);

				if (Std.is(enemy, units.Boss))
				{
					boss = cast enemy;
					side = 1;
				}

				var x = (side == 0) ? -enemy.width : FlxG.width;
				var y = random.int(0, Math.floor(FlxG.height / 2)) + FlxG.height / 4;

				if (Std.is(enemy, units.Boss))
					y = FlxG.height / 2;

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

			//CatZimaState.musicLevel();
		}
	}

	function checkPause()
	{
		if (FlxG.keys.anyJustPressed(["ENTER"]) || FlxG.gamepads.anyJustPressed(START))
		{
			CatZimaState.playSound("confirm1", 1.0);

			if (subState == null)
				openSubState(AchievementState.init());
			else
			{
				//closeSubState();
				subState = null;
			}
		}

	}

	function loseTheLevel()
	{
		//CatZimaState.restartGame = true;
		//FlxG.switchState(new AchievementState());

		//ChoiceState.reset();

		if (bossLevel)
		{
			ChoiceState.dialogueOrGameplay = 0;
			FlxG.switchState(new ChoiceState());
		}
		else
		{
			// incremented once, so it's the first level
			if (ChoiceState.menuId == ChoiceState.MENU_HIRING)
				CatZimaState.unlockAchievement("fail");

			FlxG.switchState(new StartScreenState());
		}
	}

	function winTheLevel()
	{
		//trace("won");

		// for both tweet upgrades
		if (bugLevel)
			CatZimaState.unlockAchievement("help");
		else if (bossLevel)
			CatZimaState.unlockAchievement("nospoon");

		FlxG.switchState(new ChoiceState());
	}

	override public function update(elapsed: Float): Void
	{
		checkPause();

		if (subState == null)
		{
			super.update(elapsed);

			FlxG.camera.scroll.x += elapsed * 30;

			var hp = Math.ceil(player.health);
			for (i in 0...playerHealth.widthInTiles)
				playerHealth.setTile(i, 0, i >= hp ? 0 : 1, true);

			if (bossLevel)
			{
				if (boss != null)
				{
					var hp = Math.ceil(boss.health);
					for (i in 0...bossHealth.widthInTiles)
						bossHealth.setTile(i, 0, i >= hp ? 0 : 1, true);
				}

				FlxG.overlap(player, healthPacks, healthPackPickup);
			}

			if (bugLevel)
			{
				FlxG.overlap(CatZimaState.playerBullets, blogs, callProgrammer);
				FlxG.overlap(CatZimaState.enemies, commits, smashBug);

				/*for (c in commits)
				{
					if (c.alive)
					{
						FlxG.overlap(CatZimaState.enemies, c, smashBug);
					}
				}*/
			}

			/*if (CatZimaState.enemies.countLiving() <= 0)
			{
				//trace("won");
			}*/
		}
		
	}
}