package units;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import Type;

class GenericGuy extends FlxSprite
{
    var speed = 100.0;
    public var shootRate = 0.5;

    var overrideSpeedY: Null<Float> = null;

    public var bulletSource(default, null) = new FlxPoint(36, 25);

    var shootTimer: FlxTimer;

    public var centerX(get, never): Float;
    public var centerY(get, never): Float;

    var abilityTimer = 0.0;
    
	var invincibleTimer = 0.0;

    var animationSuffix = "";

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

    function sign(number: Float): Int
    {
        if (number == 0.0)
            return 0;

        return number > 0 ? 1 : -1;
    }

    public function setMoveDirection(directionX: Int, directionY: Int)
    {
        var v = FlxVector.get(directionX, directionY);
        var length = v.length;
        if (length != 0.0)
            v.set(v.x / length, v.y / length);

        //var oldVelocityX = velocity.x;

        velocity.set(overrideSpeedY != null ? sign(v.x) * speed : v.x * speed, overrideSpeedY != null ? sign(v.y) * overrideSpeedY : v.y * speed);

        if (velocity.x != 0.0)
        {
            facing = (velocity.x < 0) ? FlxObject.LEFT : FlxObject.RIGHT;
        }

        if (velocity.x != 0.0 || velocity.y != 0.0)
        {
            if (animation.curAnim.name != "move" + animationSuffix)
                animation.play("move" + animationSuffix, true, animation.frameIndex == 0 && animationSuffix == "");
        }
        else
        {
            if (animation.curAnim.name != "stand" + animationSuffix)
                animation.play("stand" + animationSuffix, true, animation.frameIndex == 0 && animationSuffix == "");
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

    // 'true' when appeared on the screen
    function chasePlayerY(): Bool
    {
        var player = CatZimaState.player;

        var dx = 0;
        var posX = 25;

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

        var onScreen = (x >= 0 && x <= FlxG.width - width);

        setMoveDirection(dx, onScreen ? Math.round(player.centerY - centerY) : 0);

        return onScreen;
    }

    function goAway()
    {
        var dx = 0;
        if (centerX > FlxG.width / 2)
        {
            dx = 1;
            
            facing = FlxObject.RIGHT;
        }
        else
        {
            dx = -1;

            facing = FlxObject.LEFT;
        }

        setMoveDirection(dx, 0);
    }

    // 'true' when not going to move
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
        var teleport_flipX = flipX;
        CatZimaState.spawnEffect(effects.Teleport, centerX, centerY, null, teleport_flipX);

        setPosition(FlxG.width - centerX - width / 2, y);
        last.set(x, y);

        CatZimaState.spawnEffect(effects.TeleportArrive, centerX, centerY, null, !teleport_flipX);
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
                
                //var teleport_flipX = flipX;
                //CatZimaState.spawnEffect(effects.Teleport, centerX, centerY, null, teleport_flipX);

                teleport();

                //CatZimaState.spawnEffect(effects.TeleportArrive, centerX, centerY, null, !teleport_flipX);

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
        if (!Std.is(this, units.HealthPack))
        {
            CatZimaState.spawnEffect(effects.EnemyBoom, centerX, centerY);
        }

        super.kill();

        //exists = true;
    }

    override public function hurt(amount: Float)
    {
        if (amount < 0)
        {
            super.hurt(amount);
        }
        else if (invincibleTimer <= 0)   
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

        //shootTimer.cancel();
    }

    function distance(s1: FlxSprite, s2: FlxSprite): Float
    {
        var dx = (s1.x + s1.width / 2) - (s2.x + s2.width / 2);
        var dy  = (s1.y + s1.height / 2) - (s2.y + s2.height / 2);

        return Math.sqrt(dx*dx + dy*dy);
    }

    function generateUnit(unitType: Class<GenericGuy>, unitNearby: GenericGuy, reversed: Bool = false, group: FlxGroup = null): GenericGuy
	{
        var targetGroup = group == null ? CatZimaState.enemies : group;
		var newEnemy: GenericGuy = cast targetGroup.recycle(cast unitType);
		var distance = 1.0;

        var flip = unitNearby.facing == FlxObject.LEFT;
        if (reversed)
            flip = !flip;
        
		var offset = flip ? unitNearby.width + unitNearby.width * distance : -distance * unitNearby.width - newEnemy.width;

		newEnemy.reset(unitNearby.x + offset, unitNearby.y);
		newEnemy.facing = unitNearby.facing;

		CatZimaState.spawnEffect(effects.TrollCast, newEnemy.centerX, newEnemy.centerY);

		return cast newEnemy;
	}

}