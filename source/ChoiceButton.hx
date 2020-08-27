package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.addons.ui.FlxUI9SliceSprite;

class ChoiceButton extends FlxGroup
{
    var background: FlxSprite;
    var description: FlxText;
    var icon: FlxSprite = null;
    //var lockedIcon: FlxSprite = null;

    var innerMargin = 10;

    var margin = 0;

    var textFieldBoost: Float;

    public var speed: Int = 0;

    public var x(default, null): Float;
    public var y(default, null): Float;
    public var alpha: Float = 1.0;
    public var time: Float = 0.0;

	public function new(text: String, x: Int, y: Int, margin: Int, height: Float, iconPath: String = null, slotType: String = "Slot", width: Float = 1.0, textFieldBoost: Float = 0.0)
	{
		super();

        this.margin = margin;
        this.textFieldBoost = textFieldBoost;

        //loadGraphic("assets/images/units/" + graphic + ".png", false);

        //background = new FlxSprite();
        //background.makeGraphic(Math.floor(FlxG.width) - margin * 2, Math.floor(FlxG.height * height) - margin * 2, 0xff007700);
        //background.loadGraphic("assets/images/ui/Slot3.png");
        background = new FlxUI9SliceSprite(0, 0, 'assets/images/ui/${slotType}.png', 
            new openfl.geom.Rectangle(0, 0, Math.floor(FlxG.width * width) - margin * 2, Math.floor(FlxG.height * height) - margin * 2), 
            [6, 6, 21, 19], FlxUI9SliceSprite.TILE_BOTH);
        //background.setSize(Math.floor(FlxG.width) - margin * 2, Math.floor(FlxG.height * height) - margin * 2);
        background.scrollFactor.set();
        background.updateHitbox();

        background.alpha = 0.75;
        

        if (iconPath != null)
        {
            icon = new FlxSprite();
            //icon.loadGraphic(Math.floor(FlxG.width) - margin * 2, Math.floor(FlxG.height * height) - margin * 2, 0xff007700);
            icon.loadGraphic("assets/images/" + iconPath + ".png", true, 50, 50);
            icon.scrollFactor.set();
            icon.updateHitbox();
            
            /*lockedIcon = new FlxSprite();
            //icon.loadGraphic(Math.floor(FlxG.width) - margin * 2, Math.floor(FlxG.height * height) - margin * 2, 0xff007700);
            icon.loadGraphic("assets/images/" + iconPath + ".png", true, 50, 50);
            icon.scrollFactor.set();
            icon.updateHitbox();*/
        }

        description = new Text(text);

        /*if (iconPath != null)
        {
            description.reset(background.x + icon.width + 2 * innerMargin, background.y + innerMargin / 2);
        }
        else
        {
            description.reset(background.x + innerMargin, background.y + innerMargin / 2);
        }*/

        moveTo(x, y);

        add(background);
        add(description);

        if (iconPath != null)
        {
            add(icon);
        }
	}

    public function setAlpha(value: Float)
    {
        background.alpha = value;
    }

    public function moveTo(x: Float, y: Float): Void
    {
        //super.reset(x, y);

        this.x = x;
        this.y = y;

        background.reset(x + margin, y + margin);

        if (icon != null)
        {
            icon.reset(background.x + innerMargin, background.y + background.height / 2 - icon.height / 2);

            description.reset(background.x + icon.width + 2 * innerMargin, background.y + innerMargin / 2);
        }
        else
        {
            description.reset(background.x + innerMargin, background.y + innerMargin / 2);
        }

        description.fieldWidth = background.width - (description.x - background.x) - innerMargin + textFieldBoost;
    }

    // for achievements
   /* public function setLocked(mode: Bool)
    {
        ;
    }*/

    public function overlaps(object: FlxBasic): Bool
    {
        return background.overlaps(object);
    }

    public function setText(text: String)
    {
        description.text = text;
    }

    public function getText(): String
    {
        return description.text;
    }

    public function disableCollision()
    {
        background.allowCollisions = FlxObject.NONE;

        if (icon != null)
            icon.allowCollisions = FlxObject.NONE;

        description.allowCollisions = FlxObject.NONE;
    }

	override public function update(elapsed: Float): Void
	{
        if (speed != 0)
        {
            moveTo(x, y - speed * elapsed);
            //moveTo(x + speed * elapsed, y - speed * elapsed);

            if (!background.isOnScreen())
                kill();
            
           /* alpha += elapsed * 0.5;
            if (alpha > 1)
                alpha = alpha % 1;*/

            /*time += elapsed;
            alpha = Math.cos(time * 3) * 0.5 + 0.5;
            
            background.alpha = alpha;
            //icon.alpha = alpha;
            description.alpha = alpha;*/
        }

		super.update(elapsed);

	}
}
