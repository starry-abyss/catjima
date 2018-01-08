package;

import flixel.FlxG;
import flixel.text.FlxText;

class Text extends FlxText
{
    public function new(t: String)
    {
        super();

        text = t;
        size = 8;
        borderSize = 0;
        antialiasing = false;
        font = CatZimaState.fontPath;
        scrollFactor.set();
    }
}