package cdev.script;

import haxe.Exception;
import sys.FileSystem;
import haxe.io.Path;

typedef CDevModScript =
{
	var daPath:String;
	var daMod:String;
}

class CDevScript
{
    public var fileName:String = "";
	public var daScript:CDevModScript;
    public var mod:String = null;
	public static var haxeExts:Array<String> = ['hx', 'hscript'];

	public function new()
	{
	}

	public static function newFromPath(path):CDevScript
	{
		var script = create(path);
		if (script != null)
		{
			script.loadFile(path);
			return script;
		}
		else
		{
			return null;
		}
	}

	public static function create(filePath:String):CDevScript
	{
		var path = SUtil.getStorageDirectory() + filePath;
		trace('CDEVSCRIPT CREATE FUNCTION $path');
		if (FileSystem.exists(path))
		{
			trace('file exists');
			return new HScript();
		}
		return null;
	}

	public function executeFunc(funcName:String, ?args:Array<Any>):Dynamic
	{
		throw new Exception("Not Implemented!!");
		return null;
	}

	public function setVariable(name:String, val:Dynamic)
	{
		throw new Exception("Not Implemented!!");
	}

	public function getVariable(name:String):Dynamic
	{
		throw new Exception("Not Implemented!!");
		return null;
	}

	public function trace(text:String)
	{
		trace(text);
	}

	public function loadFile(path:String)
	{
		throw new Exception("Not Implemented!!");
	}

	public function destroy()
	{
	}
}
