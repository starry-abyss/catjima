package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		FlxG.fixedTimestep = false;

		//addChild(new FlxGame(320, 180, StartScreenState));
		addChild(new FlxGame(320, 180, LogoState, 1, 60, 60, true, false));
		//addChild(new FlxGame(320, 180, ChoiceState));
	}
}