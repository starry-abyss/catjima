package effects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.effects.particles.FlxEmitter;

class GenericParticleEffect extends FlxTypedEmitter<Particle>
{
	public function new(graphic: Class<Particle>, width: Int, height: Int)
	{
		super();

        /*loadGraphic("assets/images/effects/" + graphic + ".png", true, width, height);
        updateHitbox();

        animation.finishCallback = animationEnd;*/


        //scrollFactor.set();

        //trace(particleClass);

        //particleClass = Particle;
        particleClass = graphic;
        setSize(width, height);

        for (i in 0...5)
        {
            //var p = new TrollParticle();
            var p = Type.createInstance(particleClass, []);
            p.exists = false;
            add(p);
        }

        //makeParticles(2, 2, 0xff00ff00, 1);

        //alive = false;
	}

    public function reset(x: Float, y: Float)
    {
        setPosition(x, y);
        
        revive();
    }

    override public function revive()
    {
        //super.revive();

        //animation.play("stand");
        
        start(true, 1, 5);
    }

    /*override function onFinished(): Void
	{
        super.onFinished();

        trace("pf");

        
    }*/

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

        if (alive)
        {
            if (countLiving() <= 0)
            {
                trace("pf");

                kill();
            }
        }
	}

    /*function animationEnd(_)
    {
        kill();
    }*/
}