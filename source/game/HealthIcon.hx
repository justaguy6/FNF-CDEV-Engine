package game;

import sys.FileSystem;
import lime.utils.Assets;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	var charList:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));

	public var charColorArray:Array<FlxColor> = [];
	private var char:String;
	private var iconOffset:Array<Float> = [0, 0];
	private var isPlayer:Bool = false;
	public var hasWinningIcon:Bool = false;

	var first_x:Float = 0;
	var first_y:Float = 0;
	public var add_y:Float = 0;
	public var add_x:Float = 0;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		this.char = char;
		this.isPlayer = isPlayer;
		super();

		changeDaIcon(char);
		scrollFactor.set();
	}

	public function changeDaIcon(char:String) {
		//bruh.
		var name:String = 'icons/' + char;
		if(!cdev.CDevConfig.utils.fileIsExists('images/' + name + '.png', IMAGE))
			name = 'icons/'+char+'-icon';
		if(!cdev.CDevConfig.utils.fileIsExists('images/' + name + '.png', IMAGE))
			name = 'icons/face-icon'; //to prevent crashing while loading an not existed character icon
		

		var file:Dynamic = Paths.image(name);
		//trace(file);

		var testSprite:FlxSprite = new FlxSprite().loadGraphic(file);
		
		loadGraphic(file, true, 150, 150);

		//winning icon
		if (testSprite.width >= 301 && testSprite.width <= 450) {
			animation.add(char, [0, 1, 2], 0, false, isPlayer);
			hasWinningIcon = true;
		} else{
			animation.add(char, [0, 1], 0, false, isPlayer);
			hasWinningIcon = false;
		}
		
		animation.play(char);
		this.char = char;

		iconOffset[0] = (width - 150) / 2;
		iconOffset[1] = (height - 150) / 2;
		antialiasing = FlxG.save.data.antialiasing;
		if (char.endsWith('-pixel'))
			antialiasing = false;	
	}
	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffset[0];
		offset.y = iconOffset[1];
	}

	public function getChar():String{
		return char;
	}

	override public function setPosition(x:Float = 0.0, y:Float = 0.0):Void {
		super.setPosition(x,y);
		first_x = x;
		first_y = y;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10 + add_x, sprTracker.y - 30 + add_y);
		else
			setPosition(first_x+add_x,first_y+add_y);
	}
}
