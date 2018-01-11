package effects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.effects.particles.FlxEmitter;

class TrollParticle extends Particle
{
	public function new(/*graphic: String, width: Int, height: Int*/)
	{
		super();

        /*loadGraphic("assets/images/effects/" + graphic + ".png", true, width, height);
        updateHitbox();

        animation.finishCallback = animationEnd;*/
        //trace("particle");

        scrollFactor.set();

        makeGraphic(6, 6, 0xff00ff00);
	}
}

class TrollCast extends GenericParticleEffect
{
	public function new()
	{
		super(TrollParticle, 30, 30);

        alpha.set(0.5, 0.5, 0.0, 0.0);

        speed.set(10, 10, 0, 0);

        lifespan.set(1, 1);

        /*scale.start.min.set(1, 1);
        scale.start.max.set(1, 1);
        scale.end.min.set(0, 0);
        scale.end.max.set(0, 0);*/
	}

}