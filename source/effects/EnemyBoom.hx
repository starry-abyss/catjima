package effects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;

class EnemyBoom extends GenericEffect
{
	public function new()
	{
		super("explosion Test", 64, 64);
       
        animation.add("stand", [0, 1, 2, 3, 4, 5, 6], 10, false);

        revive();
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);
	}
}