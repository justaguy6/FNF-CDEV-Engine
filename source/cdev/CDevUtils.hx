package cdev;

import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.math.FlxPoint;
import haxe.io.Path;
import flixel.util.FlxAxes;
import game.Conductor;
import game.Conductor.BPMChangeEvent;
import flixel.ui.FlxButton;
import lime.system.Clipboard;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import sys.FileSystem;
import flixel.math.FlxMath;
import openfl.Assets;
import flixel.FlxG;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import game.Paths;

using StringTools;

class CDevUtils
{
	/**
	 * boundshit
	 */
	public function new()
	{
	}

	public function readChartJsons(songname:String, mod:Bool = false)
	{
		// difficulties are created based on the file's filename, ex: tutorial-hard.json , the difficulty is "hard";
		var diffs:Array<String> = [];
		var f:Array<String> = [];
		var p:String = "";
		if (!mod)
		{
			p = Paths.chartPath(songname);
			f = FileSystem.readDirectory(Paths.chartPath(songname));
		}
		else
		{
			p = Paths.modChartPath(songname);
			f = FileSystem.readDirectory(Paths.modChartPath(songname));
		}

		trace(p);
		trace(f);

		for (i in 0...f.length)
		{
			if (f[i].endsWith(".json"))
			{
				var a:String = f[i].replace(songname, "");
				if (a.contains("-"))
				{
					var splittedName:Array<String> = a.replace(".json", "").split("-");

					// taking the last array
					diffs.push(splittedName[splittedName.length - 1]);
				}
				else
				{
					diffs.push("normal+");
				}
			}
		}

		return diffs;
	}
	public function bound(toConvert:Float, min:Float, max:Float):Float
	{
		return FlxMath.bound(toConvert, min, max); // ye
	}

	public function pasteFunction(prefix:String = ''):String
	{
		if (prefix.toLowerCase().endsWith('v'))
			prefix = prefix.substring(0, prefix.length - 1);

		var txt:String = prefix + Clipboard.text.replace('\n', '');
		return txt;
	}

	/**
	 * Moving the `obj1` to `obj2`'s center position
	 * @param obj1 
	 * @param obj2 
	 * @param useFrameSize 
	 */
	public function moveToCenterOfSprite(obj1:FlxSprite, obj2:FlxSprite, ?useFrameSize:Bool)
	{
		if (useFrameSize)
		{
			obj1.setPosition((obj2.x + (obj2.frameWidth / 2) - (obj1.frameWidth / 2)), (obj2.y + (obj2.frameHeight / 2) - (obj1.frameHeight / 2)));
		}
		else
		{
			obj1.setPosition((obj2.x + (obj2.width / 2) - (obj1.width / 2)), (obj2.y + (obj2.height / 2) - (obj1.height / 2)));
		}
	}

	/**
	 * Centering `object` to screen
	 * (This is different from FlxSprite.screenCenter())
	 * @param object 			The object that you want to move
	 * @param pos				X or Y (FlxAxes)
	 */
	public function objectScreenCenter(object:FlxSprite, ?pos:FlxAxes = null)
	{
		if (pos == null)
		{
			object.x = (FlxG.width / 2) - ((object.frameWidth * object.scale.x) / 2);
			object.y = (FlxG.height / 2) - ((object.frameHeight * object.scale.y) / 2);
		}

		if (pos == X)
			object.x = (FlxG.width / 2) - ((object.frameWidth * object.scale.x) / 2);

		if (pos == Y)
			object.y = (FlxG.height / 2) - ((object.frameHeight * object.scale.y) / 2);
	}

	public function setFlxButtonLabelOffset(object:FlxButton, x:Float, y:Float)
	{
		for (offset in object.labelOffsets)
		{
			offset.set(x, y);
		}
	}

	// hi :) credit: Shadow Mario#9396
	public function fileIsExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String)
	{
		#if ALLOW_MODS
		if (FileSystem.exists(Paths.mods(Paths.currentMod + '/' + key)) || FileSystem.exists(Paths.mods(key)))
			return true;
		#end

		if (OpenFlAssets.exists(Paths.getPath(key, type)))
		{
			return true;
		}
		return false;
	}

	public function getColor(sprite:FlxSprite):FlxColor
	{
		var color:Map<Int, Int> = [];

		for (col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var pixelColor:Int = sprite.pixels.getPixel32(col, row);
				if (pixelColor != 0)
				{
					if (color.exists(pixelColor))
					{
						color[pixelColor] = color[pixelColor] + 1;
					}
					else if (color[pixelColor] != 13520687 - (2 * 13520687))
					{
						color[pixelColor] = 1;
					}
				}
			}
		}

		color[FlxColor.BLACK] = 0;

		var maxCount = 0;
		var maxKey:Int = 0;

		for (key in color.keys())
			if (color[key] >= maxCount)
			{
				maxCount = color[key];
				maxKey = key;
			}

		return FlxColor.fromInt(maxKey);
	}

	public function cacheUISounds()
	{
		if (!Assets.cache.hasSound(Paths.sound('cancelMenu', 'preload')))
		{
			FlxG.sound.cache(Paths.sound('cancelMenu', 'preload'));
		}

		if (!Assets.cache.hasSound(Paths.sound('scrollMenu', 'preload')))
		{
			FlxG.sound.cache(Paths.sound('scrollMenu', 'preload'));
		}
		if (!Assets.cache.hasSound(Paths.sound('confirmMenu', 'preload')))
		{
			FlxG.sound.cache(Paths.sound('confirmMenu', 'preload'));
		}
	}

	public function openURL(url:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [url, "&"]);
		#else
		FlxG.openURL(url);
		#end
	}

	/**
	 * Caching sounds. just input the filename, and the library.
	 */
	public function doSoundCaching(sound:String, ?library:String = null):Void
	{
		if (!Assets.cache.hasSound(Paths.sound(sound, library)))
		{
			FlxG.sound.cache(Paths.sound(sound, library));
		}
	}

	/**
	 * Music Caching
	 */
	public function doMusicCaching(musicPath:String)
	{
		if (!Assets.cache.hasSound(Paths.inst(musicPath)))
		{
			FlxG.sound.cache(Paths.inst(musicPath));
		}
	}
}
