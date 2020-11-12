package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class BriefingState extends CatZimaState
{
    var player: units.CatZima;
    var choices: Array<ChoiceButton>;

    var startButton: FlxSprite;

    public static var hintId = HINT_HARDCORE;

    public static inline var HINT_BLONDE = 0;
    public static inline var HINT_HARDCORE = 1;
    public static inline var HINT_TROLL = 2;
    public static inline var HINT_BUG = 3;
    public static inline var HINT_STREAMER = 4;
    public static inline var HINT_STREAMER_SAVE = 5;
    public static inline var HINT_STREAMER_KILL = 6;
    public static inline var HINT_JOURNALIST = 7;
    public static inline var HINT_BOSS = 8;
    public static inline var HINT_IDEA = 9;
    public static inline var HINT_NO_JOURNALIST = 10;

	override public function create():Void
	{
		super.create();

        var background = new FlxSprite();
        background.loadGraphic("assets/images/background.png");
        background.scrollFactor.set();
        add(background);

        var hint: ChoiceButton = null;

        switch (hintId)
        {
            case HINT_BLONDE:
                hint = new ChoiceButton("Unhappy to this choice: Casual player\n\nThey tap you to death if no games on the mobile phone!", 0, 0, 10, 4/9, "units/blonde");

            case HINT_HARDCORE:
                hint = new ChoiceButton("Unhappy to this choice: Hardcore player\n\nMerged with the gamepad. Reaction - like a ninja!", 0, 0, 10, 4/9, "units/hardcore");

            case HINT_TROLL:
                hint = new ChoiceButton("Unhappy basically: Anonymous troll\n\nAvoid ANY contact! Affects others.", 0, 0, 10, 4/9, "units/trololoshka");

            case HINT_BUG:
                hint = new ChoiceButton("Unhappy to this choice: Bug after update\n\nIntroduced by Agent Smith. Call the programmers!", 0, 0, 10, 4/9, "units/bug");

            case HINT_STREAMER:
                hint = new ChoiceButton("Unhappy to this choice: Streamer\n\nThe audience is used to text-based branching.", 0, 0, 10, 4/9, "units/streamer");

            case HINT_STREAMER_SAVE:
                hint = new ChoiceButton("The rescued streamer realized that he was wrong, thanked you for being gentle with him, and unlocked an emoticon with a heart for you.", 0, 0, 10, 4/9, "units/health");
            
            case HINT_STREAMER_KILL:
                hint = new ChoiceButton("After a rough showdown, the streamers are greatly offended. But on the other hand, Gamin wrote a review of your game and compared it to Dark Souls.", 0, 0, 10, 4/9, "units/streamer");
            
            case HINT_JOURNALIST:
                hint = new ChoiceButton("The journalists are happy about bug fixes and ask their friends on Twitter to double the damage from messages.", 0, 0, 10, 4/9, "units/tweetShot2xIcon");
            
            case HINT_NO_JOURNALIST:
                hint = new ChoiceButton("Journalists cannot complete the game due to bugs. And those who did manage to, write negative reviews.", 0, 0, 10, 4/9, "units/bug");

            case HINT_BOSS:
                hint = new ChoiceButton("Unhappy You Are Still Alive: Agent Smith\n\nSo that's who forms the opinion of the players!", 0, 0, 10, 4/9, "units/boss");

            case HINT_IDEA:
                var i = CatZimaState.random.int(0, 3);
                var text = 
                    if (i == 0)
                        "Cat Jíma:\n\n\"Let me post a photo of hugs with a robot!\"";
                    else if (i == 1)
                        "Cat Jíma:\n\n\"And yet I'm a genius!\"";
                    else if (i == 2)
                        "Cat Jíma:\n\n\"It's time to come up with a sequel!\"";
                    else //if (i == 3)
                        "Cat Jíma:\n\n\"Mole Yneux and weregoose Purrhard are resting!\"";
                    
                hint = new ChoiceButton(text, 0, 0, 10, 4/9, "units/sdf");
                

            default: {}
        }

        
        //var choice2 = new ChoiceButton("Выбор 2: Управление геймпадом", 0, 120, 10);
        choices = [ hint ];

        player = CatZimaState.player;

        

        startButton = new FlxSprite(Math.floor(FlxG.width * 3 / 4 - 30), Math.floor(FlxG.height * 3 / 4 - 30));
        startButton.loadGraphic("assets/images/ui/blog.png", false);
        startButton.updateHitbox();
        startButton.scrollFactor.set();


        //startButton = new ChoiceButton("Блог", Math.floor(FlxG.width * 3 / 4 - 50), Math.floor(FlxG.height * 3 / 4 - 50), 10, 1/3);
        var blog = new Text("microblog");
        blog.reset(startButton.x + startButton.width + 5, startButton.y + 5);
        blog.color = 0xffffffff;
        blog.borderSize = 1;
        blog.borderColor = 0x80000000;
        blog.borderStyle = OUTLINE;


        player.reset(Math.floor(FlxG.width * 1 / 4 - player.width / 2), Math.floor(FlxG.height * 3 / 4 - player.height / 2 - 20));
		
        for (c in choices)
        {
            add(c);
        }

        add(startButton);
        add(blog);

        add(player);
        add(CatZimaState.playerBullets);

        player.allowMove = false;

        bgColor = 0;
        
        
        if (hintId == HINT_BLONDE)
        {
            var keyHintText = new Text("   Press       to send a tweet");
            keyHintText.reset(20, 160);
            //keyHintText.color = 0xff000000;
            keyHintText.color = 0xffffffff;
            keyHintText.borderSize = 1;
            keyHintText.borderColor = 0x80000000;
            keyHintText.borderStyle = OUTLINE;
            add(keyHintText);

            var keyHint = new FlxSprite();
            keyHint.scrollFactor.set();
            add(keyHint);

            if (units.CatZima.allowKeyboard)
            {
                keyHint.loadGraphic("assets/images/ui/Space Button.png");
                keyHint.reset(95, 160);
            }
            else
            {
                keyHint.loadGraphic("assets/images/ui/Button A.png");
                keyHint.reset(105, 157);
            }
        }

        add(AchievementMessage.init());
        //AchievementMessage.showMessage("test!");

        add(exitState = new ExitState());
	}

	override public function update(elapsed:Float):Void
	{
        if (exitState.isOpen())
            return;
            
		super.update(elapsed);
		
		CatZimaState.syncMusic(elapsed);

        if (startButton.overlaps(CatZimaState.playerBullets))
        {
            FlxG.switchState(new PlayState());
        }
        
	}

}
