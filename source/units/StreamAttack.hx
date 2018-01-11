package units;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.graphics.frames.FlxFrame;

class StreamAttack extends GenericBullet
{
	public function new()
	{
		super("tweetShot", true, 11, 12);

		animation.add("stand", [0/*, 1*/], 3, true);
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
			if (!camera.visible || !camera.exists /*|| !isOnScreen(camera)*/)
				continue;
			
			getScreenPosition(_point, camera); //.subtractPoint(offset);
			
			//if (isSimpleRender(camera))
			var originalX = _point.x;
			//var originalWidth = _flashRect.width;
			//var originalWidth = frameWidth;
			//var currentX = originalX;

			if (facing == FlxObject.LEFT)
			{
				_point.x = x + width - frameWidth;
			}

			var startingX = _point.x;

			while (Math.abs(_point.x - startingX) < width)
			{
				/*var nextWidth = width - Math.abs(_point.x - originalX);
				if (nextWidth > originalWidth)
					nextWidth = originalWidth;
				else if (nextWidth < originalWidth)
				{
					trace(_flashRect.width, nextWidth);
					_flashRect.width = nextWidth;
				}*/

				drawSimple(camera);

				//trace(_point.x);

				if (facing == FlxObject.LEFT)
					_point.x -= frameWidth;
				else
					_point.x += frameWidth;

				//_point.x += frameWidth;
			}

			_point.x = originalX;
			//_flashRect.width = originalWidth;
			//_flashRect.width = width;
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