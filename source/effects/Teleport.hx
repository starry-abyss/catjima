package effects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;

class Teleport extends GenericEffect
{
	public function new()
	{
		super("hardcore fast", 32, 32);
       
        animation.add("stand", [0, 1, 2, 3], 10, false);

        revive();
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);
	}
}