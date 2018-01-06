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
import flixel.util.FlxTimer;

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
    }

    static function shootBullet(bullet: units.GenericBullet)
    {
        bullet.shoot();
    }

    static public function spawnEffect(effectClass: Class<FlxBasic>, x: Float, y: Float)
    {
        var effect: FlxSprite = cast effects.recycle(effectClass);

        effect.reset(x - effect.width / 2, y - effect.height / 2);
    }

	override public function create():Void
	{
        timerManager = new FlxTimerManager();

		super.create();

		FlxG.camera.pixelPerfectRender = true;
		FlxG.worldDivisions = 1;

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
        cast(p, units.GenericGuy).onTouch();
        cast(e, units.GenericGuy).onTouch();
    }

    function enemyHitByBullet(e, b)
    {
        e.hurt(1);
        b.kill();
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (!restartGame)
        {
            FlxG.overlap(player, enemyBullets, playerHitByBullet);
            FlxG.overlap(enemies, playerBullets, enemyHitByBullet);

            FlxG.overlap(player, enemies, playerHitByEnemy);

            FlxG.collide(enemies, enemies);
        }
        else
        {
            FlxG.switchState(new ChoiceState());
        }
        
	}
}