package effects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class TweetBoom extends GenericEffect
{
	public function new(graphic: String, width: Int, height: Int)
	{
		super("shotExplosion", 32, 32);
       
        animation.add("stand", [0, 1, 2, 3, 4], 10, false);

        revive();

        scrollFactor.set();
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);
	}
}