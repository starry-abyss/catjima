package units;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class GenericGuy extends FlxSprite
{
    var speed = 100.0;
    var shootRate = 0.5;
    
    public var bulletSource(default, null) = new FlxPoint(36, 25);

    var shootTimer = new FlxTimer();

    var centerX(get, never): Float;
    var centerY(get, never): Float;

	public function new(graphic: String)
	{
		super();

        loadGraphic("assets/images/units/" + graphic + ".png", true, 50, 50);
        //updateHitbox();
        setSize(20, 30);

        centerOffsets();
       
        animation.add("stand", [0, 1], 3, true);
        animation.play("stand");

        scrollFactor.set();

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);
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
}