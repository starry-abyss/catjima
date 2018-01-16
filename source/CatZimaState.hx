package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import effects.GenericParticleEffect;
import units.GenericGuy;
import effects.GenericEffect;

class CatZimaState extends FlxState
{
	static public var player: units.CatZima;
	/*static var enemies = new FlxGroup();

	static var playerBullets = new FlxGroup();
	static var enemyBullets = new FlxGroup();

    static var effects = new FlxGroup();*/

    public static var enemies: FlxGroup;

	public static var playerBullets: FlxGroup;
	public static var enemyBullets: FlxGroup;

    static var effects: FlxGroup;

    public static var timerManager: FlxTimerManager;

    // 'true' after losing or beating the game
    public static var restartGame: Bool = false;

    //public static inline var fontPath = "assets/fonts/UpheavalPro.ttf";
    public static inline var fontPath = "assets/fonts/ps2p/PressStart2P.ttf";

    static var musicBeat: FlxSound = null;
    static var musicTrack1: FlxSound = null;
    static var musicTrack2: FlxSound = null;

    static var volumeInLevel = 0.9;
    static var volumeInMenu = 0.5;
    static var musicMode = -1;

    static inline var MUSIC_MENU = 0;
    static inline var MUSIC_INTER = 1;
    static inline var MUSIC_LEVEL = 2;

    static var random = new FlxRandom();

    public static function playSound(name: String, volume: Float = 1.0)
    {
        var sound = FlxG.sound.play("assets/sounds/" + name + ".wav", volume);
        sound.persist = true;
    }

    public static function playSoundRandom(name: String, volume: Float, max: Int)
    {
        var number = random.int(1, max);
        FlxG.sound.play("assets/sounds/" + name + '${number}.wav', volume);
    }

    public static function playSoundChunkRandom(name: String, volume: Float, length: Float)
    {
        //var sound = FlxG.sound.play("assets/sounds/" + name + ".wav", volume);
        var sound = new FlxSound();
        sound.loadEmbedded("assets/sounds/" + name + ".wav", false, true);
        //sound.persist = false;
        //sound.pause();

        var startingPos = Math.floor(random.float(0.0, sound.length - length * 1000));

        //trace(startingPos * 1000, (startingPos + length) * 1000, length * 1000);

        //sound.resume();
        sound.play(false, startingPos, startingPos + length * 1000);

        // workaround for endTime not working, also enveloping
        sound.volume = 0.0;
        var attack = 0.1;
        var release = 0.1;
        FlxTween.tween(sound, { volume: volume }, attack)
            .wait(length - attack - release)
            .then(FlxTween.tween(sound, { volume: 0 }, release, { onComplete: function (_) sound.stop() }));
    }

    static function initMusic(volume: Array<Float>)
    {
        if (musicBeat == null)
        {
            musicBeat = new FlxSound();
            musicBeat.loadEmbedded("assets/music/Beat.ogg", true, false);
            musicBeat.persist = true;
            musicBeat.volume = volume[0];
            musicBeat.play();

            musicTrack1 = new FlxSound();
            musicTrack1.loadEmbedded("assets/music/Track1.ogg", true, false);
            musicTrack1.persist = true;
            musicTrack1.volume = volume[1];
            musicTrack1.play();

            musicTrack2 = new FlxSound();
            musicTrack2.loadEmbedded("assets/music/Track2.ogg", true, false);
            musicTrack2.persist = true;
            musicTrack2.volume = volume[2];
            musicTrack2.play();
            
            return true;
        }

        musicBeat.fadeOut(1.0, volume[0]);
        musicTrack1.fadeOut(1.0, volume[1]);
        musicTrack2.fadeOut(1.0, volume[2]);

        return false;
    }

    public static function musicMenu()
    {
        if (musicMode != MUSIC_MENU)
            initMusic([0, 0, volumeInMenu]);
        
        musicMode = MUSIC_MENU;
    }

    public static function musicInter()
    {
        if (musicMode != MUSIC_INTER)
            initMusic([volumeInMenu, 0, 0]);
        
        musicMode = MUSIC_INTER;
    }

    public static function musicLevel()
    {
        if (musicMode != MUSIC_LEVEL)
            initMusic([volumeInLevel, volumeInLevel, 0]);
        
        musicMode = MUSIC_LEVEL;
    }

    static public function shootTweetBullet()
    {
        var bullet: units.TweetBullet = cast playerBullets.recycle(units.TweetBullet);

        var offsetX = player.facing == FlxObject.LEFT ? player.frameWidth - player.bulletSource.x : player.bulletSource.x;
        var offsetY = /*player.facing == FlxObject.LEFT ? player.frameHeight - player.bulletSource.y :*/ player.bulletSource.y;

        bullet.reset(
            player.x - (player.frameWidth - player.width) / 2 + offsetX - bullet.width / 2,
            player.y - (player.frameHeight - player.height) / 2 + offsetY - bullet.height / 2
            );
        bullet.facing = player.facing;

        shootBullet(bullet);

        playSoundRandom("tweet", 1.0, 4);

        if (Std.is(FlxG.state, BriefingState))
            musicLevel();
    }

    static function shootBullet(bullet: units.GenericBullet)
    {
        bullet.shoot();
    }

    static public function spawnEffect(effectClass: Class<FlxBasic>, x: Float, y: Float, parent: GenericGuy = null)
    {
        var effect = effects.recycle(effectClass);

        if (Std.is(effect, FlxSprite))
        {
            cast(effect, FlxSprite).reset(x - cast(effect, FlxSprite).width / 2, y - cast(effect, FlxSprite).height / 2);
            //cast(effect, FlxSprite).flipX = flipX;

            if (parent != null)
            {
                cast(effect, GenericEffect).parent = parent;
                cast(effect, GenericEffect).offsetX = x;
                cast(effect, GenericEffect).offsetY = y;
            }
        }
        else if (Std.is(effect, GenericParticleEffect))
        {
            cast(effect, GenericParticleEffect).reset(x - cast(effect, GenericParticleEffect).width / 2, y - cast(effect, GenericParticleEffect).height / 2);
        }

    }

	override public function create():Void
	{
        timerManager = new FlxTimerManager();

		super.create();

		FlxG.camera.pixelPerfectRender = true;
		FlxG.worldDivisions = 1;
        FlxG.fixedTimestep = false;

        player = new units.CatZima();

        FlxG.stage.color = 0x3F757D;
        FlxG.mouse.visible = false;
        //FlxG.keys.reset

        player.reset(FlxG.width / 2 - player.width / 2, FlxG.height / 2 - player.height / 2);

        enemies = new FlxGroup();
        playerBullets = new FlxGroup();
	    enemyBullets = new FlxGroup();

        effects = new FlxGroup();

        player.allowShoot = true;
        player.allowMove = true;

        add(timerManager);
	}

    function playerHitByBullet(p, b)
    {
        cast(p, units.GenericGuy).onTouch();
        b.kill();
    }

    function playerHitByEnemy(p, e)
    {
        if (Std.is(e, units.Streamer))
        {
            cast(e, units.Streamer).softKill();
        }
        else if (!Std.is(e, units.Bug))
        {
            cast(p, units.GenericGuy).onTouch();
            cast(e, units.GenericGuy).onTouch();
        }
    }

    function enemyHitByBullet(e, b)
    {
        if (!Std.is(e, units.Bug))
        {
            e.hurt(1);
            b.kill();
        }
    }

    function bulletByBullet(b1, b2)
    {
        if (!Std.is(b1, units.StreamAttack))
            b1.kill();

        if (!Std.is(b2, units.StreamAttack))
            b2.kill();
    }

    function enemyCollide(?ObjectOrGroup1: FlxBasic, ?ObjectOrGroup2: FlxBasic): Bool
	{
        function separate(o1: FlxObject, o2: FlxObject): Bool
        {
            if (!Std.is(o1, units.Casual) && !Std.is(o2, units.Casual))
            {
                return FlxObject.separateY(o1, o2);
            }
            return false;
        }

		return FlxG.overlap(ObjectOrGroup1, ObjectOrGroup2, null, separate);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (!restartGame)
        {
            FlxG.overlap(player, enemyBullets, playerHitByBullet);
            FlxG.overlap(enemies, playerBullets, enemyHitByBullet);

            FlxG.overlap(enemyBullets, playerBullets, bulletByBullet);

            FlxG.overlap(player, enemies, playerHitByEnemy);

            enemyCollide(enemies, enemies);
        }
        else
        {
            FlxG.switchState(new ChoiceState());
        }
        
	}
}