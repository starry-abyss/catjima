package units;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class CatZima extends GenericGuy
{
	public function new()
	{
		super("sdf");

		health = 3;
	}

	override public function onTouch()
    {
        hurt(1);
    }

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

		var player = this;

		var directionX = 0;
		var directionY = 0;
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			directionX -= 1;
		}
		if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			directionX += 1;
		}
		if (FlxG.keys.anyPressed(["UP", "W"]))
		{
			directionY -= 1;
		}
		if (FlxG.keys.anyPressed(["DOWN", "S"]))
		{
			directionY += 1;
		}

		player.setMoveDirection(directionX, directionY);

		if (FlxG.keys.anyPressed(["SPACE", "J"]))
		{
			if (shootPrepare())
				CatZimaState.shootTweetBullet();
		}

		var borderSize = 24;

		if (player.x < 0)
			player.x = 0;
			
		if (player.y < borderSize)
			player.y = borderSize;
			
		if (player.x > FlxG.width - player.width)
			player.x = FlxG.width - player.width;
		
		if (player.y > FlxG.height - borderSize - player.height)
			player.y = FlxG.height - borderSize - player.height;
	}
}