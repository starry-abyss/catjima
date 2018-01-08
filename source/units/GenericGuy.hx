package units;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import Type;

class GenericGuy extends FlxSprite
{
    var speed = 100.0;
    var shootRate = 0.5;

    public var bulletSource(default, null) = new FlxPoint(36, 25);

    var shootTimer: FlxTimer;

    public var centerX(get, never): Float;
    public var centerY(get, never): Float;

    var abilityTimer = 0.0;
    
	var invincibleTimer = 0.0;


	public function new(graphic: String)
	{
		super();

        setGraphic(graphic);

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);

        shootTimer = new FlxTimer(CatZimaState.timerManager);
	}

    function setGraphic(graphic: String)
    {
        loadGraphic("assets/images/units/" + graphic + ".png", true, 50, 50);
        //updateHitbox();
        setSize(20, 30);

        centerOffsets();
       
        animation.add("stand", [0, 1], 1, true);
        //animation.play("stand");

        animation.add("move", [0, 1], 3, true);
        animation.play("move");

        scrollFactor.set();
    }

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        if (abilityTimer > 0.0)
		{
			abilityTimer -= elapsed;
		}

        if (invincibleTimer > 0.0)
		{
			invincibleTimer -= elapsed;

			alpha = Math.sin(invincibleTimer * 15) * 0.5 + 0.5;
		}
		else
		{
			alpha = 1;
		}
	}

    public function setMoveDirection(directionX: Int, directionY: Int)
    {
        var v = FlxVector.get(directionX, directionY);
        var length = v.length;
        if (length != 0.0)
            v.set(v.x / length, v.y / length);

        //var oldVelocityX = velocity.x;

        velocity.set(v.x * speed, v.y * speed);

        if (velocity.x != 0.0)
        {
            facing = (velocity.x < 0) ? FlxObject.LEFT : FlxObject.RIGHT;
        }

        if (velocity.x != 0.0 || velocity.y != 0.0)
        {
            if (animation.curAnim.name != "move")
                animation.play("move", true, animation.frameIndex == 0);
        }
        else
        {
            if (animation.curAnim.name != "stand")
                animation.play("stand", true, animation.frameIndex == 0);
        }

        v.put();
    }

    function shootPrepare(): Bool
    {
        if (shootTimer.active)
        {
            return false;
        }

        shootTimer.start(shootRate, function (_) {}, 1);
        return true;
    }

    function chasePlayer()
    {
        var player = CatZimaState.player;
        setMoveDirection(Math.round(player.centerX - centerX), Math.round(player.centerY - centerY));
    }

    function chasePlayerY()
    {
        var player = CatZimaState.player;

        var dx = 0;
        var posX = 25;

        if (centerX < FlxG.width / 2)
        {
            if (centerX < posX)
                dx = 1;
        }
        else
        {
            if (centerX > FlxG.width - posX)
                dx = -1;
        }

        setMoveDirection(dx, Math.round(player.centerY - centerY));
    }

    function standStill(posX: Float): Bool
    {
        var player = CatZimaState.player;

        var dx = 0;
        //var posX = 25;

        if (centerX < FlxG.width / 2)
        {
            if (centerX < posX)
                dx = 1;
            
            facing = FlxObject.RIGHT;
        }
        else
        {
            if (centerX > FlxG.width - posX)
                dx = -1;

            facing = FlxObject.LEFT;
        }

        setMoveDirection(dx, 0);

        return (dx == 0);
    }

    function teleport()
    {
        setPosition(FlxG.width - centerX - width / 2, y);
        last.set(x, y);
    }

    function teleportIfBullet()
    {
        if (abilityTimer <= 0.0)
        {
            var needTeleport = false;

            CatZimaState.playerBullets.forEachAlive(
                function (b: FlxBasic)
                {
                    //trace(Type.typeof(b));
                    var bullet = cast(b, GenericBullet);

                    //trace(Math.abs(centerX - bullet.centerX) + Math.abs(centerY - bullet.centerY));

                    if (
                        (Math.abs(centerX - bullet.centerX) < 100)
                        && (Math.abs(centerY - bullet.centerY) < bullet.height + height / 2)
                        && (bullet.facing != facing)
                        )
                            needTeleport = true;
                }
            );

            if (needTeleport)
            {
                abilityTimer = 1.5;
                teleport();

                CatZimaState.playSoundRandom("ninja_shift", 1.0, 3);
            }
        }
    }

    function get_centerX(): Float
    {
        return x + width / 2;
    }

    function get_centerY(): Float
    {
        return y + height / 2;
    }

    public function onTouch()
    {

    }
    
	override public function kill()
    {
        // if (isOnScreen())
        {
            CatZimaState.spawnEffect(effects.EnemyBoom, centerX, centerY);
        }

        super.kill();

        //exists = true;
    }

    override public function hurt(amount: Float)
    {
        if (invincibleTimer <= 0)
		{
			invincibleTimer = 1.0;
        	super.hurt(amount);
		}
        
    }

    override public function reset(x: Float, y: Float)
    {
        super.reset(x, y);

        abilityTimer = 0.0;
	    invincibleTimer = 0.0;
    }

}