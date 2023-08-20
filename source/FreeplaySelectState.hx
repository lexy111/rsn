package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop; 
import flixel.text.FlxText;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxOutlineEffect;


class FreeplaySelectState extends MusicBeatState{
    public static var freeplayCats:Array<String> = ['week1', 'week2', 'bonus', 'covers'];
    public static var curCategory:Int = 0;
	public var NameAlpha:Alphabet;

	private var iconArray:Array<HealthIcon> = [];

	var grpCats:FlxTypedGroup<Alphabet>;

	var curSelected:Int = 0;
	var BG:FlxSprite;
	var hintBG:FlxSprite;
	var varPattern:Float = 0;
	var hintText:FlxText;
	var bgPatterns:FlxBackdrop; 
    override function create(){
        BG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		BG.scale.x = 1;
		BG.scale.y = 1;
		BG.updateHitbox();
		BG.screenCenter();
		//BG.color = 0xFF00c2ff; //Me when aagh
		add(BG);

		hintBG = new FlxSprite(0, 0).makeGraphic(660, 60, 0xFF000000);
		hintBG.alpha = 0.6;
		add(hintBG);

		hintText = new FlxText(0, 0, 2000, 'Choose a set songs of the week');
		hintText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE);
		add(hintText);
				bgPatterns = new FlxBackdrop(Paths.image('backdrop'), 0.2, 0.2, true, true, 0, 0); 
				//checker.velocity.set(112, 110); 
				bgPatterns.updateHitbox(); 
				bgPatterns.scrollFactor.set(0, 0.3); 
				bgPatterns.alpha = 0.5; 
				bgPatterns.screenCenter(Y); 
				bgPatterns.antialiasing = ClientPrefs.globalAntialiasing;
				add(bgPatterns);
        grpCats = new FlxTypedGroup<Alphabet>();
		add(grpCats);
        for (i in 0...freeplayCats.length)
        {
			var catsText:Alphabet = new Alphabet(0, (70 * i) + 30, freeplayCats[i], true, false);
            catsText.targetY = i;
            catsText.isMenuItem = true;
			grpCats.add(catsText);

			var icon:HealthIcon = new HealthIcon(freeplayCats[i]);
			icon.sprTracker = catsText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			
		}

		NameAlpha = new Alphabet(20,(FlxG.height / 2) - 282,freeplayCats[curSelected],true,false);
		NameAlpha.screenCenter(X);
		Highscore.load();
		//add(NameAlpha);
        changeSelection();
        super.create();
    }
	override function beatHit()
	{
		//trace("Beat Hitted")
		varPattern = 1;
		super.beatHit();
	}
    override public function update(elapsed:Float){
        
		if (controls.UI_UP_P) 
			changeSelection(-1);
		if (controls.UI_DOWN_P) 
			changeSelection(1);
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
        if (controls.ACCEPT){
            MusicBeatState.switchState(new FreeplayState());
        }
	bgPatterns.x += 30  * elapsed;
			bgPatterns.y -= 30 * elapsed;

			varPattern = FlxMath.lerp(varPattern,0,0.1);
        curCategory = curSelected;

        super.update(elapsed);
    }

    function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = freeplayCats.length - 1;
		if (curSelected >= freeplayCats.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpCats.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;
			item.alpha = 0.4;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}

		NameAlpha.destroy();
		NameAlpha = new Alphabet(20,(FlxG.height / 2) - 282,freeplayCats[curSelected],true,false);
		NameAlpha.screenCenter(X);
		//add(NameAlpha);
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}