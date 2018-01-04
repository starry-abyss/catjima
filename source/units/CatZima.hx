package units;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.input.gamepad.FlxGamepadInputID;

class CatZima extends GenericGuy
{
	var allowKeyboard = true;
	var allowGamepad = true;

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
		if (checkLeft())
		{
			directionX -= 1;
		}
		if (checkRight())
		{
			directionX += 1;
		}
		if (checkUp())
		{
			directionY -= 1;
		}
		if (checkDown())
		{
			directionY += 1;
		}

		player.setMoveDirection(directionX, directionY);

		if (checkAction())
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

	function checkLeft(): Bool
	{
		if (allowKeyboard && FlxG.keys.anyPressed(["LEFT", "A"]))
			return true;
		
		if (allowGamepad && FlxG.gamepads.anyPressed(DPAD_LEFT))
			return true;

		if (allowGamepad && FlxG.gamepads.anyPressed(LEFT_STICK_DIGITAL_LEFT))
			return true;
		
		return false;
	}

	function checkRight(): Bool
	{
		if (allowKeyboard && FlxG.keys.anyPressed(["RIGHT", "D"]))
			return true;
		
		if (allowGamepad && FlxG.gamepads.anyPressed(DPAD_RIGHT))
			return true;

		if (allowGamepad && FlxG.gamepads.anyPressed(LEFT_STICK_DIGITAL_RIGHT))
			return true;
			
		return false;
	}

	function checkUp(): Bool
	{
		if (allowKeyboard && FlxG.keys.anyPressed(["UP", "W"]))
			return true;
		
		if (allowGamepad && FlxG.gamepads.anyPressed(DPAD_UP))
			return true;

		if (allowGamepad && FlxG.gamepads.anyPressed(LEFT_STICK_DIGITAL_UP))
			return true;
			
		return false;
	}

	function checkDown(): Bool
	{
		if (allowKeyboard && FlxG.keys.anyPressed(["DOWN", "S"]))
			return true;
		
		if (allowGamepad && FlxG.gamepads.anyPressed(DPAD_DOWN))
			return true;

		if (allowGamepad && FlxG.gamepads.anyPressed(LEFT_STICK_DIGITAL_DOWN))
			return true;
			
		return false;
	}

	function checkAction(): Bool
	{
		if (allowKeyboard && FlxG.keys.anyPressed(["SPACE", "J"]))
			return true;
		
		if (allowGamepad && FlxG.gamepads.anyPressed(A))
			return true;

		if (allowGamepad && FlxG.gamepads.anyPressed(B))
			return true;
			
		return false;
	}
}