package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.math.FlxMath;

class ChoiceButton extends FlxGroup
{
    var background: FlxSprite;
    var description: FlxText;
    var icon: FlxSprite;

	public function new(text: String, x: Int, y: Int, margin: Int, height: Float, iconPath: String = null)
	{
		super();

        var innerMargin = 10;

        //loadGraphic("assets/images/units/" + graphic + ".png", false);

        background = new FlxSprite();
        background.makeGraphic(Math.floor(FlxG.width) - margin * 2, Math.floor(FlxG.height * height) - margin * 2, 0xff007700);
        background.scrollFactor.set();
        background.updateHitbox();
        background.reset(x + margin, y + margin);

        if (iconPath != null)
        {
            icon = new FlxSprite();
            //icon.loadGraphic(Math.floor(FlxG.width) - margin * 2, Math.floor(FlxG.height * height) - margin * 2, 0xff007700);
            icon.loadGraphic("assets/images/" + iconPath + ".png", true, 50, 50);
            icon.scrollFactor.set();
            icon.updateHitbox();
            icon.reset(background.x + innerMargin, background.y + background.height / 2 - icon.height / 2);
        }

        description = new FlxText();
        description.text = text;
        description.size = 8;
        description.borderSize = 0;
        description.antialiasing = false;
        description.font = CatZimaState.fontPath;
        description.scrollFactor.set();

        if (iconPath != null)
        {
            description.reset(background.x + icon.width + 2 * innerMargin, background.y + innerMargin / 2);
        }
        else
        {
            description.reset(background.x + innerMargin, background.y + innerMargin / 2);
        }

        description.fieldWidth = background.width - (description.x - background.x) - innerMargin;

        add(background);
        add(description);

        if (iconPath != null)
            add(icon);
	}

    public function overlaps(object: FlxBasic): Bool
    {
        return background.overlaps(object);
    }

	override public function update(elapsed: Float): Void
	{
		super.update(elapsed);

	}
}
