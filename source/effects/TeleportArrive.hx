package effects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;

class TeleportArrive extends GenericEffect
{
	public function new()
	{
		super("hardcore fast", 32, 32);
       
        animation.add("stand", [3, 2, 1, 0], 10, false);

        revive();
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);
	}
}