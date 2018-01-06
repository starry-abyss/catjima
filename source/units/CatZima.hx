package units;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.input.gamepad.FlxGamepadInputID;

class CatZima extends GenericGuy
{
	public static var allowKeyboard = true;
	public static var allowGamepad = true;

	public var allowShoot = true;
	public var allowMove = true;
	//public var waitToAllowMove = false;

	public var waitMoveTimer = 0.0;

	public function new()
	{
		super("sdf");

		health = ChoiceState.hireBonus == 1 ? 7 : 5;
		speed = 150;

		shootRate = ChoiceState.hireBonus == 0 ? 0.35 : 0.5;
	}

	override public function reset(x: Float, y: Float)
    {
        super.reset(x, y);

        waitMoveTimer = 0.0;
    }

	override public function onTouch()
    {
		/*if (invincibleTimer <= 0)
		{
			invincibleTimer = 2.0;
        	hurt(1);
		}*/

		hurt(1);
    }

	override public function kill()
	{
		/*if (alive)
		{
			CatZimaState.restartGame = true;
			//FlxG.switchState(new AchievementState());
		}*/

		super.kill();
	}

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

		if (waitMoveTimer > 0.0)
		{
			waitMoveTimer -= elapsed;
		}

		var player = this;

		var directionX: Int = 0;
		var directionY: Int = 0;
		//if (allowMove || waitToAllowMove)
		if (allowMove && (waitMoveTimer <= 0.0))
		{
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

			/*if (waitToAllowMove)
			{
				if ((directionX == 0) && (directionY == 0))
				{
					waitToAllowMove = false;
					allowMove = true;
				}
				else
				{
					directionX = 0;
					directionY = 0;
				}
			}*/
		}

		player.setMoveDirection(directionX, directionY);

		if (allowShoot && checkAction())
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