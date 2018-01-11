package effects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Particle extends FlxParticle
{
	public function new(/*graphic: String, width: Int, height: Int*/)
	{
		super();

        /*loadGraphic("assets/images/effects/" + graphic + ".png", true, width, height);
        updateHitbox();

        animation.finishCallback = animationEnd;*/
        //trace("particle");

        scrollFactor.set();

        //makeGraphic(2, 2, 0xff00ff00);
	}
}