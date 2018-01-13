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

        //makeGraphic(6, 6, 0xff00ff00);
        loadGraphic("assets/images/effects/Poison Smoke.png", true, 20, 20);
        animation.add("stand", [0, 1, 2, 3], 8, false);
        animation.play("stand");
	}
}

class TrollCast extends GenericParticleEffect
{
	public function new()
	{
		super(TrollParticle, 30, 30);

        //alpha.set(0.5, 0.5, 0.0, 0.0);

        speed.set(10, 10, 0, 0);

        lifespan.set(0.5, 0.5);

        //loadParticles("assets/images/effects/Poison Smoke.png", 100);

        /*scale.start.min.set(1, 1);
        scale.start.max.set(1, 1);
        scale.end.min.set(0, 0);
        scale.end.max.set(0, 0);*/
	}

}