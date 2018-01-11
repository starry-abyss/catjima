package units;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.graphics.frames.FlxFrame;

class StreamAttack extends GenericBullet
{
	public function new()
	{
		super("sdf", true, 50, 50);

		animation.add("stand", [0, 1], 3, true);
        animation.play("stand");
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

		FlxG.overlap(this, CatZimaState.playerBullets, 
				function (eb, pb)
				{
					pb.kill();
				}
			);
    }

	override public function kill()
    {
		// do nothing, only can be killed from the attacker
    }

	override public function draw():Void
	{
		checkEmptyFrame();
		
		if (alpha == 0 || _frame.type == FlxFrameType.EMPTY)
			return;
		
		if (dirty) //rarely 
			calcFrame(useFramePixels);
		
		for (camera in cameras)
		{
			if (!camera.visible || !camera.exists || !isOnScreen(camera))
				continue;
			
			getScreenPosition(_point, camera).subtractPoint(offset);
			
			//if (isSimpleRender(camera))
			var originalX = _point.x;
			//var currentX = originalX;
			while (Math.abs(_point.x - originalX) < width)
			{
				drawSimple(camera);

				//trace(_point.x);

				/*if (facing == FlxObject.LEFT)
					_point.x -= frameWidth;
				else
					_point.x += frameWidth;
					*/

				_point.x += frameWidth;
			}

			_point.x = originalX;
			//else
			//	drawComplex(camera);
			
			#if FLX_DEBUG
			FlxBasic.visibleCount++;
			#end
		}
		
		#if FLX_DEBUG
		if (FlxG.debugger.drawDebug)
			drawDebug();
		#end
	}
}