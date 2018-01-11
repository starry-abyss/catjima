package effects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;

class TrollFace extends GenericEffect
{
	public function new()
	{
		super("trololoshka", 50, 50);
       
        animation.add("stand", [0, 1, 0], 3, false);

        revive();
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);
	}
}