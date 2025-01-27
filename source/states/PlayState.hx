package states;

import game.Stage.SpriteStage;
import cdev.script.CDevScript;
import substates.GameOverSubstate;
import flixel.tweens.misc.VarTween;
import game.Conductor.BPMChangeEvent;
import engineutils.TraceLog;
import sys.io.File;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import flixel.util.FlxAxes;
import flixel.addons.text.FlxTypeText;
import engineutils.FlxColor_Util;
import modding.ModPaths;
import flixel.system.FlxAssets;
import openfl.display.BitmapData;
import haxe.io.Path;
import cdev.script.HScript;
import cdev.script.ScriptData;
import cdev.script.ScriptSupport;
import flixel.group.FlxSpriteGroup;
import lime.app.Application;
import sys.FileSystem;
import lime.media.openal.AL;
import openfl.media.Sound;
#if desktop
import engineutils.Discord.DiscordClient;
import openfl.Assets as FLAssets;
#end
import openfl.Lib;
import song.Section.SwagSection;
import song.Song.SwagSong;
import shaders.WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import shaders.WiggleEffect;
import game.*;
import cdev.*;
import song.*;
import modding.CharacterData;
import modding.CharacterEditor;

using StringTools;

class PlayState extends MusicBeatState
{
	static inline final REMOVEDOBJECT = 'removedObject';

	public var vars:Map<String, Dynamic> = [];

	var bfCamX:Int = 0;
	var bfCamY:Int = 0;

	var dadCamX:Int = 0;
	var dadCamY:Int = 0;

	public var BFXPOS:Float = 770;
	public var BFYPOS:Float = 100;
	public var DADXPOS:Float = 100;
	public var DADYPOS:Float = 100;
	public var GFXPOS:Float = 400;
	public var GFYPOS:Float = 130;

	public static var fromMod:String = '';

	public var grpNotePresses:FlxTypedGroup<NotePress>;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekName:String = '';

	var songName:FlxText;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	var songPercent:Float = 0;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	// private var vocals_opponent:FlxSound;
	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public static var notes:FlxTypedGroup<Note>;

	var toDoEvents:Array<ChartEvent> = [];

	private var unspawnNotes:Array<Note> = [];
	private var strumLine:FlxSprite;

	public static var strumXpos:Float = 35;

	private var curSection:Int = 0;

	public static var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var camZooming:Bool = false;

	public static var convertedAccuracy:Float = 0;

	var accuracyShit:Float = 0;

	public static var strumLineNotes:FlxTypedGroup<StrumArrow>;
	public static var playerStrums:FlxTypedGroup<StrumArrow>;
	public static var p2Strums:FlxTypedGroup<StrumArrow>;

	var stageGroup:FlxTypedGroup<SpriteStage>;
	var stageHandler:Stage;
	var stageFrontGroup:Array<SpriteStage> = [];

	private var curSong:String = "";

	public var gfSpeed:Int = 1;

	public static var health:Float = 1;

	private var healthLerp:Float = 1;
	private var combo:Int = 0;

	var bruhZoom:Float = 0;
	var isDownscroll:Bool = false;

	public static var healthBarBG:FlxSprite;
	public static var healthBar:FlxBar;

	// the mods
	public static var randomNote:Bool = false;
	public static var suddenDeath:Bool = false;
	public static var scrSpd:Float = 1;
	public static var healthGainMulti:Float = 1;
	public static var healthLoseMulti:Float = 1;
	public static var comboMultiplier:Float = 1;
	public static var songSpeed:Float = 1.0;
	public static var playingLeftSide:Bool = false;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	var pressedNotes:Int = 0;

	public static var iconP1:HealthIcon;
	public static var iconP2:HealthIcon;
	public static var camHUD:FlxCamera;

	var camTrace:FlxCamera;

	public var camGame:FlxCamera;

	public static var botplayTxt:FlxText;

	var zoomin:Float = 0;

	var camPos:FlxPoint;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var halloweenThunder:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var daRPCInfo:String = '';

	var ratingText:String = "";

	// week7
	var tankWatchtower:FlxSprite;
	var tankGround:FlxSprite;
	var tankBG:FlxTypedGroup<BackgroundTankmen>;
	var foregroundSprites:FlxTypedGroup<FlxSprite>;

	var songPosBGspr:FlxSprite;
	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;

	public var songScore:Int = 0;

	public static var scoreTxt:FlxText;

	var scoreWidth:Int = 0;

	private var cheeringBF:Bool = false;

	public static var campaignScore:Int = 0;

	public static var defaultCamZoom:Float = 1.05;
	public static var defaultHudZoom:Float = 1;

	var bgScore:FlxSprite;
	var bgNoteLane:FlxSprite;

	var judgementText:FlxText;

	public var ratingIdk:String;

	var difficultytxt:String = "";

	var alreadyTweened:Bool = false;

	public static var perfect:Int = 0;
	public static var sick:Int = 0;
	public static var good:Int = 0;
	public static var bad:Int = 0;
	public static var shit:Int = 0;
	public static var misses:Int = 0;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	public static var isPixel:Bool = false;

	var inCutscene:Bool = false;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	public static var difficultyName:String = "";

	public static var scripts:ScriptData;
	public static var intro_cutscene_script:CDevScript;
	public static var outro_cutscene_script:CDevScript;

	var currentCutscene:String = ""; // intro, outro;

	public static var stageScript:ScriptData;
	public static var current:PlayState = new PlayState();

	var bfCamXPos:Float = 0;
	var bfCamYPos:Float = 0;
	var dadCamXPos:Float = 0;
	var dadCamYPos:Float = 0;

	public static var cameraPosition:FlxObject;

	public static var chartingMode:Bool = false;

	var sRating:FlxSprite;
	var numGroup:FlxTypedGroup<FlxSprite>;

	var traceWindow:TraceLog;

	public static var config:PlayStateConfig = null;

	public static var forceCameraPos:Bool = false;
	public static var camPosForced:Array<Float> = [];

	var isModStage:Bool = false;

	override public function create()
	{
		config = new PlayStateConfig();
		// PlayStateConfig.resetConfig();
		Paths.destroyLoadedImages(false);
		if (FlxG.save.data.showTraceLogAt == 1)
			TraceLog.resetLogText();

		CDevConfig.setExitHandler(function()
		{
		});
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		health = 1;
		camZooming = false;
		defaultCamZoom = 1.09;
		defaultHudZoom = 1;

		forceCameraPos = false;
		camPosForced = [];

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camTrace = new FlxCamera();
		camTrace.bgColor.alpha = 0;
		camFollow = null;
		cameraPosition = null;
		// difficultyName = "";

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camTrace);

		config.noteImpactsCamera = camHUD;
		config.ratingSpriteCamera = camHUD;

		// FlxG.cameras.setDefaultDrawTarget(camGame, false);
		FlxCamera.defaultCameras = [camGame];
		// FlxCamera.defaultCameras

		persistentUpdate = true;
		persistentDraw = true;

		if (FlxG.save.data.showTraceLogAt == 1)
		{
			traceWindow = new TraceLog(10, 60, 660, 250);
			add(traceWindow);
			traceWindow.cameras = [camTrace];
			FlxG.mouse.visible = true;
		}

		randomNote = FlxG.save.data.randomNote;
		suddenDeath = FlxG.save.data.suddenDeath;
		scrSpd = FlxG.save.data.scrollSpeed;
		healthGainMulti = FlxG.save.data.healthGainMulti;
		healthLoseMulti = FlxG.save.data.healthLoseMulti;
		comboMultiplier = FlxG.save.data.comboMultipiler;
		songSpeed = FlxMath.roundDecimal(FreeplayState.speed, 2);
		playingLeftSide = FreeplayState.playOnLeftSide;
		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);
		Conductor.updateSettings();
		if (FlxG.save.data.downscroll)
		{
			isDownscroll = true;
		}
		else
		{
			isDownscroll = false;
		}
		ScriptSupport.currentMod = fromMod;
		// trace("ScriptSupport.currentMod: " + fromMod);
		ScriptSupport.parseSongConfig();
		scripts = new ScriptData(ScriptSupport.scripts);
		// trace('ScriptSupport.scripts = ' + ScriptSupport.scripts);
		scripts.loadFiles();

		Paths.currentMod = fromMod;
		// this is bad
		// intro_cutscene_script = new CDevScript();
		var introExist:Bool = false;
		var outroExist:Bool = false;
		trace(Paths.modChartPath(SONG.song + "/intro.hx"));
		if (FileSystem.exists(Paths.modChartPath(SONG.song + "/intro.hx")))
		{
			trace("existed.");
			introExist = true;
			intro_cutscene_script = CDevScript.create(Paths.modChartPath(SONG.song + "/intro.hx"));
		}

		trace(Paths.modChartPath(SONG.song + "/outro.hx"));
		if (FileSystem.exists(Paths.modChartPath(SONG.song + "/outro.hx")))
		{
			trace("existed.");
			outroExist = true;
			outro_cutscene_script = CDevScript.create(Paths.modChartPath(SONG.song + "/outro.hx"));
		}

		if (introExist)
		{
			intro_cutscene_script.loadFile(Paths.modChartPath(SONG.song + "/intro.hx"));

			// variables
			ScriptSupport.setScriptDefaultVars(intro_cutscene_script, fromMod, {});
			intro_cutscene_script.setVariable("FlxTypeText", flixel.addons.text.FlxTypeText);
		}

		if (outroExist)
		{
			outro_cutscene_script.loadFile(Paths.modChartPath(SONG.song + "/outro.hx"));

			// variables
			ScriptSupport.setScriptDefaultVars(outro_cutscene_script, fromMod, {});
			outro_cutscene_script.setVariable("FlxTypeText", flixel.addons.text.FlxTypeText);
		}

		sick = 0;
		good = 0;
		bad = 0;
		shit = 0;
		misses = 0;
		convertedAccuracy = 0;

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.dialogTxt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.dialogTxt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.dialogTxt('thorns/thornsDialogue'));
		}

		var originalXPos:Float = 65;

		if (FlxG.save.data.middlescroll)
			originalXPos = -260;
		// originalXPos = -278;

		strumXpos = originalXPos;

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = SONG.song + " " + storyDifficultyText + " Story Mode";
		}
		else
		{
			detailsText = SONG.song + " " + storyDifficultyText + " Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		daRPCInfo = 'Score: ' + songScore + "\n" + 'Misses: ' + misses + '\n' + 'Accuracy: ' + RatingsCheck.fixFloat(convertedAccuracy, 2) + "% ("
			+ ratingText + ')';

		// Updating Discord Rich Presence.
		if (Main.discordRPC)
			DiscordClient.changePresence(detailsText, daRPCInfo, iconRPC);
		#end

		switch (storyDifficulty)
		{
			case 0:
				difficultytxt = "Easy";
			case 1:
				difficultytxt = "Normal";
			case 2:
				difficultytxt = "Hard";
		}

		var builtinstages:Array<String> = [
			'stage',
			'spooky',
			'philly',
			'limo',
			'mall',
			'mallEvil',
			'school',
			'schoolEvil',
			'tank'
		];
		stageGroup = new FlxTypedGroup<SpriteStage>();

		isPixel = false;

		if (builtinstages.contains(SONG.stage))
		{
			switch (SONG.stage)
			{
				case 'stage':
					{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = FlxG.save.data.antialiasing;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);

						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = FlxG.save.data.antialiasing;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;

						add(stageCurtains);
					}
				case 'spooky':
					{
						curStage = 'spooky';
						halloweenLevel = true;

						var hallowTex = Paths.getSparrowAtlas('halloween_bg', 'week2');

						halloweenBG = new FlxSprite(-200, -100);
						halloweenBG.frames = hallowTex;
						halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
						halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
						halloweenBG.animation.play('idle');
						halloweenBG.antialiasing = FlxG.save.data.antialiasing;
						add(halloweenBG);

						halloweenThunder = new FlxSprite(-500, -500).makeGraphic(4000, 4000, FlxColor.WHITE);
						halloweenThunder.alpha = 0;
						halloweenThunder.blend = ADD;

						isHalloween = true;
					}
				case 'philly':
					{
						curStage = 'philly';

						var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
						bg.scrollFactor.set(0.1, 0.1);
						add(bg);

						var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
						city.scrollFactor.set(0.3, 0.3);
						city.setGraphicSize(Std.int(city.width * 0.85));
						city.updateHitbox();
						add(city);

						phillyCityLights = new FlxTypedGroup<FlxSprite>();
						add(phillyCityLights);

						for (i in 0...5)
						{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = FlxG.save.data.antialiasing;
							phillyCityLights.add(light);
						}

						var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain', 'week3'));
						add(streetBehind);

						phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train', 'week3'));
						add(phillyTrain);

						trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes', 'week3'));
						FlxG.sound.list.add(trainSound);

						// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

						var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street', 'week3'));
						add(street);
					}
				case 'limo':
					{
						curStage = 'limo';
						defaultCamZoom = 0.90;

						var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset', 'week4'));
						skyBG.scrollFactor.set(0.1, 0.1);
						add(skyBG);

						var bgLimo:FlxSprite = new FlxSprite(-200, 480);
						bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo', 'week4');
						bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
						bgLimo.animation.play('drive');
						bgLimo.scrollFactor.set(0.4, 0.4);
						add(bgLimo);

						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);

						for (i in 0...5)
						{
							var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
							dancer.scrollFactor.set(0.4, 0.4);
							grpLimoDancers.add(dancer);
						}

						var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay', 'week4'));
						overlayShit.alpha = 0.5;
						// add(overlayShit);

						// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

						// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

						// overlayShit.shader = shaderBullshit;

						var limoTex = Paths.getSparrowAtlas('limo/limoDrive', 'week4');

						limo = new FlxSprite(-120, 550);
						limo.frames = limoTex;
						limo.animation.addByPrefix('drive', "Limo stage", 24);
						limo.animation.play('drive');
						limo.antialiasing = FlxG.save.data.antialiasing;

						fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol', 'week4'));
						// add(limo);
					}
				case 'mall':
					{
						curStage = 'mall';

						defaultCamZoom = 0.80;

						var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls', 'week5'));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.2, 0.2);
						bg.active = false;
						bg.setGraphicSize(Std.int(bg.width * 0.8));
						bg.updateHitbox();
						add(bg);

						upperBoppers = new FlxSprite(-240, -90);
						upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop', 'week5');
						upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
						upperBoppers.antialiasing = FlxG.save.data.antialiasing;
						upperBoppers.scrollFactor.set(0.33, 0.33);
						upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
						upperBoppers.updateHitbox();
						add(upperBoppers);

						var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator', 'week5'));
						bgEscalator.antialiasing = FlxG.save.data.antialiasing;
						bgEscalator.scrollFactor.set(0.3, 0.3);
						bgEscalator.active = false;
						bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
						bgEscalator.updateHitbox();
						add(bgEscalator);

						var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree', 'week5'));
						tree.antialiasing = FlxG.save.data.antialiasing;
						tree.scrollFactor.set(0.40, 0.40);
						add(tree);

						bottomBoppers = new FlxSprite(-300, 140);
						bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop', 'week5');
						bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
						bottomBoppers.antialiasing = FlxG.save.data.antialiasing;
						bottomBoppers.scrollFactor.set(0.9, 0.9);
						bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
						bottomBoppers.updateHitbox();
						add(bottomBoppers);

						var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow', 'week5'));
						fgSnow.active = false;
						fgSnow.antialiasing = FlxG.save.data.antialiasing;
						add(fgSnow);

						santa = new FlxSprite(-840, 150);
						santa.frames = Paths.getSparrowAtlas('christmas/santa', 'week5');
						santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
						santa.antialiasing = FlxG.save.data.antialiasing;
						add(santa);
					}
				case 'mallEvil':
					{
						curStage = 'mallEvil';
						var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG', 'week5'));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.2, 0.2);
						bg.active = false;
						bg.setGraphicSize(Std.int(bg.width * 0.8));
						bg.updateHitbox();
						add(bg);

						var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree', 'week5'));
						evilTree.antialiasing = FlxG.save.data.antialiasing;
						evilTree.scrollFactor.set(0.2, 0.2);
						add(evilTree);

						var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow", 'week5'));
						evilSnow.antialiasing = FlxG.save.data.antialiasing;
						add(evilSnow);
					}
				case 'school':
					{
						config.uiTextFont = 'Pixel Arial 11 Bold';
						isPixel = true;
						curStage = 'school';

						// defaultCamZoom = 0.9;

						var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky', 'week6'));
						bgSky.scrollFactor.set(0.1, 0.1);
						add(bgSky);

						var repositionShit = -200;

						var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool', 'week6'));
						bgSchool.scrollFactor.set(0.6, 0.90);
						add(bgSchool);

						var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet', 'week6'));
						bgStreet.scrollFactor.set(0.95, 0.95);
						add(bgStreet);

						var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack', 'week6'));
						fgTrees.scrollFactor.set(0.9, 0.9);
						add(fgTrees);

						var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
						var treetex = Paths.getPackerAtlas('weeb/weebTrees', 'week6');
						bgTrees.frames = treetex;
						bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
						bgTrees.animation.play('treeLoop');
						bgTrees.scrollFactor.set(0.85, 0.85);
						add(bgTrees);

						var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
						treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals', 'week6');
						treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
						treeLeaves.animation.play('leaves');
						treeLeaves.scrollFactor.set(0.85, 0.85);
						add(treeLeaves);

						var widShit = Std.int(bgSky.width * 6);

						bgSky.setGraphicSize(widShit);
						bgSchool.setGraphicSize(widShit);
						bgStreet.setGraphicSize(widShit);
						bgTrees.setGraphicSize(Std.int(widShit * 1.4));
						fgTrees.setGraphicSize(Std.int(widShit * 0.8));
						treeLeaves.setGraphicSize(widShit);

						fgTrees.updateHitbox();
						bgSky.updateHitbox();
						bgSchool.updateHitbox();
						bgStreet.updateHitbox();
						bgTrees.updateHitbox();
						treeLeaves.updateHitbox();

						bgGirls = new BackgroundGirls(-100, 190);
						bgGirls.scrollFactor.set(0.9, 0.9);

						if (SONG.song.toLowerCase() == 'roses')
						{
							bgGirls.getScared();
						}

						bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
						bgGirls.updateHitbox();
						add(bgGirls);
					}
				case 'schoolEvil':
					{
						config.uiTextFont = 'Pixel Arial 11 Bold';
						isPixel = true;
						curStage = 'schoolEvil';

						var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
						var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

						var posX = 400;
						var posY = 200;

						var bg:FlxSprite = new FlxSprite(posX, posY);
						bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool', 'week6');
						bg.animation.addByPrefix('idle', 'background 2', 24);
						bg.animation.play('idle');
						bg.scrollFactor.set(0.8, 0.9);
						bg.scale.set(6, 6);
						add(bg);

						/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);

							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);

							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						 */

						// bg.shader = wiggleShit.shader;
						// fg.shader = wiggleShit.shader;

						/* 
							var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
							var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

							// Using scale since setGraphicSize() doesnt work???
							waveSprite.scale.set(6, 6);
							waveSpriteFG.scale.set(6, 6);
							waveSprite.setPosition(posX, posY);
							waveSpriteFG.setPosition(posX, posY);

							waveSprite.scrollFactor.set(0.7, 0.8);
							waveSpriteFG.scrollFactor.set(0.9, 0.8);

							// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
							// waveSprite.updateHitbox();
							// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
							// waveSpriteFG.updateHitbox();

							add(waveSprite);
							add(waveSpriteFG);
						 */
					}
				case 'tank':
					{
						curStage = 'tank';
						defaultCamZoom = 0.9;
						var sky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('tankSky', 'week7'));
						sky.scrollFactor.set();
						add(sky);

						var clouds:FlxSprite = new FlxSprite(FlxG.random.int(-700, -100),
							FlxG.random.int(-20, 20)).loadGraphic(Paths.image('tankClouds', 'week7'));
						clouds.scrollFactor.set(0.1, 0.1);
						clouds.active = true;
						clouds.velocity.x = FlxG.random.float(5, 15);
						add(clouds);

						var mountains:FlxSprite = new FlxSprite(-300, -20).loadGraphic(Paths.image('tankMountains', 'week7'));
						mountains.scrollFactor.set(0.2, 0.2);
						mountains.setGraphicSize(Std.int(1.2 * mountains.width));
						add(mountains);

						mountains.updateHitbox();

						var buildings:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tankBuildings', 'week7'));
						buildings.scrollFactor.set(0.3, 0.3);
						buildings.setGraphicSize(Std.int(1.1 * buildings.width));
						buildings.updateHitbox();
						add(buildings);

						var ruins:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tankRuins', 'week7'));
						ruins.scrollFactor.set(0.35, 0.35);
						ruins.setGraphicSize(Std.int(1.1 * ruins.width));
						ruins.updateHitbox();
						add(ruins);

						var smokeLeft:FlxSprite = new FlxSprite(-200, -100);
						smokeLeft.frames = Paths.getSparrowAtlas('smokeLeft', 'week7');
						smokeLeft.animation.addByPrefix('SmokeBlurLeft', 'SmokeBlurLeft', 24, true);
						smokeLeft.scrollFactor.set(0.4, 0.4);
						smokeLeft.animation.play('SmokeBlurLeft', true);
						add(smokeLeft);

						var smokeRight:FlxSprite = new FlxSprite(1100, -100);
						smokeRight.frames = Paths.getSparrowAtlas('smokeRight', 'week7');
						smokeRight.animation.addByPrefix('SmokeRight', 'SmokeRight', 24, true);
						smokeRight.scrollFactor.set(0.4, 0.4);
						smokeRight.animation.play('SmokeRight', true);
						add(smokeRight);

						tankWatchtower = new FlxSprite(100, 50);
						tankWatchtower.frames = Paths.getSparrowAtlas('tankWatchtower', 'week7');
						tankWatchtower.animation.addByPrefix('watchtower gradient color', 'watchtower gradient color', 24, false);
						tankWatchtower.scrollFactor.set(0.5, 0.5);
						add(tankWatchtower);

						tankGround = new FlxSprite(300, 300);
						tankGround.frames = Paths.getSparrowAtlas('tankRolling', 'week7');
						tankGround.animation.addByPrefix('BG tank w lightning', 'BG tank w lighting', 24, true);
						tankGround.scrollFactor.set(0.5, 0.5);
						tankGround.animation.play('BG tank w lightning', true);
						add(tankGround);

						tankBG = new FlxTypedGroup<BackgroundTankmen>();
						add(tankBG);

						var ground:FlxSprite = new FlxSprite(-420, -150).loadGraphic(Paths.image('tankGround', 'week7'));
						ground.setGraphicSize(Std.int(1.15 * ground.width));
						ground.updateHitbox();
						add(ground);
						moveTank();

						foregroundSprites = new FlxTypedGroup<FlxSprite>();
						var f:FlxSprite = new FlxSprite(-500, 650);
						var u:FlxSprite = new FlxSprite(-300, 750);
						var c:FlxSprite = new FlxSprite(450, 940);
						var k:FlxSprite = new FlxSprite(1300, 900);

						var y:FlxSprite = new FlxSprite(1620, 700);
						var r:FlxSprite = new FlxSprite(1300, 1200);

						f.frames = Paths.getSparrowAtlas('tank0', 'week7');
						f.animation.addByPrefix('fg', 'fg', 24, false);
						f.scrollFactor.set(1.7, 1.5);

						u.frames = Paths.getSparrowAtlas('tank1', 'week7');
						u.animation.addByPrefix('fg', 'fg', 24, false);
						u.scrollFactor.set(2, 0.2);

						c.frames = Paths.getSparrowAtlas('tank2', 'week7');
						c.animation.addByPrefix('fg', 'foreground', 24, false);
						c.scrollFactor.set(1.5, 1.5);

						k.frames = Paths.getSparrowAtlas('tank4', 'week7');
						k.animation.addByPrefix('fg', 'fg', 24, false);
						k.scrollFactor.set(1.5, 1.5);

						y.frames = Paths.getSparrowAtlas('tank4', 'week7');
						y.animation.addByPrefix('fg', 'fg', 24, false);
						y.scrollFactor.set(1.5, 1.5);

						r.frames = Paths.getSparrowAtlas('tank3', 'week7');
						r.animation.addByPrefix('fg', 'fg', 24, false);
						r.scrollFactor.set(3.5, 2.5);

						foregroundSprites.add(f);
						foregroundSprites.add(u);
						foregroundSprites.add(c);
						foregroundSprites.add(k);
						foregroundSprites.add(y);
						foregroundSprites.add(r);
					}
				default:
					{
						defaultCamZoom = 0.7;
						curStage = 'stage';
					}
			}
		}
		else
		{
			curStage = SONG.stage;
			add(stageGroup);
			isModStage = true;
			stageHandler = new Stage(SONG.stage, this);
			defaultCamZoom = Stage.STAGEZOOM;
			// isPixel = Stage.PIXELSTAGE;
		}
		scripts.executeFunc('createStage', []); // incase you wanted to code the stage by yourselves.

		if (isStoryMode)
		{
			randomNote = false;
			suddenDeath = false;
			scrSpd = 1;
			healthGainMulti = 1;
			healthLoseMulti = 1;
			comboMultiplier = 1;
			songSpeed = 1.0;
			playingLeftSide = false;
		}
		var gfVer:String = 'gf';
		if (SONG.gfVersion != null)
			gfVer = SONG.gfVersion;
 
		dad = new Character(DADXPOS, DADYPOS, SONG.player2);
		camPos = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
		// initCharPositions();
		gf = new Character(GFXPOS, GFYPOS, gfVer);
		moveCharToPos(gf);

		if (gfVer == 'pico-speaker' && curStage == 'tank' && tankBG != null)
		{
			var firstTank:BackgroundTankmen = new BackgroundTankmen(20, 500, true);
			firstTank.resetStatus(20, 600, true);
			firstTank.strumTime = 10;
			tankBG.add(firstTank);

			for (i in 0...BackgroundTankmen.animNotes.length)
			{
				if (FlxG.random.bool(16))
				{
					var tankk = tankBG.recycle(BackgroundTankmen);
					tankk.strumTime = BackgroundTankmen.animNotes[i][0];
					tankk.resetStatus(500, 200 + FlxG.random.int(50, 100), BackgroundTankmen.animNotes[i][1] < 2);
					tankBG.add(tankk);
				}
			}
		}

		moveCharToPos(dad, true);

		boyfriend = new Boyfriend(BFXPOS, BFYPOS, SONG.player1);
		moveCharToPos(boyfriend);

		if (isModStage)
		{
			boyfriend.x = Stage.BFPOS[0];
			boyfriend.y = Stage.BFPOS[1];
			gf.x = Stage.GFPOS[0];
			gf.y = Stage.GFPOS[1];
			dad.x = Stage.DADPOS[0];
			dad.y = Stage.DADPOS[1];
		}

		// change position of the characters if it's not a mod stage.
		if (!isModStage)
		{
			switch (curStage)
			{
				case 'limo':
					boyfriend.y = BFYPOS - 220;
					boyfriend.x = BFXPOS + 260;

					resetFastCar();
					add(fastCar);

					if (SONG.player1.toLowerCase().startsWith('bf'))
					{
						boyfriend.y += 300;
					}

				case 'mall':
					boyfriend.x = BFXPOS + 200;

				case 'mallEvil':
					boyfriend.x = BFXPOS + 320;
					dad.y = DADYPOS - 80;
				case 'school':
					boyfriend.x = BFXPOS + 200;
					boyfriend.y = BFYPOS + 220;
					gf.x = GFXPOS + 180;
					gf.y = GFYPOS + 300;
					if (SONG.player1.toLowerCase().startsWith('bf'))
					{
						boyfriend.y += 300;
					}
				case 'schoolEvil':
					// trailArea.scrollFactor.set();

					var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
					// evilTrail.changeValuesEnabled(false, false, false, false);
					// evilTrail.changeGraphic()
					add(evilTrail);
					// evilTrail.scrollFactor.set(1.1, 1.1);

					boyfriend.x = BFXPOS + 200;
					boyfriend.y = BFYPOS + 220;
					gf.x = GFXPOS + 180;
					gf.y = GFYPOS + 300;
					if (SONG.player1.toLowerCase().startsWith('bf'))
					{
						boyfriend.y += 300;
					}
				case 'tank':
					dad.y -= 50;
					gf.x -= 100;

					// if (SONG.player1.toLowerCase().startsWith('bf')) {
					//	boyfriend.y += 300;
					// }
			}
		}

		if (isModStage){
			stageHandler.createDaStage();
		}
		if (!isModStage) add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		if (!isModStage) add(dad);
		if (!isModStage) add(boyfriend);

		switch (curStage)
		{
			case 'tank':
				add(foregroundSprites);
		}

		camPosInit();
		dadGFCheck();

		switch (gf.curCharacter)
		{
			case 'boomBoxCHR':
				gf.y += 230;
		}

		if (curStage == 'spooky')
			add(halloweenThunder);

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		if (SONG.song.toLowerCase() == 'mod-test')
			gf.visible = false;

		scripts.executeFunc('create', []);

		strumLine = new FlxSprite(strumXpos, 70).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 160;

		bgNoteLane = new FlxSprite().makeGraphic(500, FlxG.height, FlxColor.BLACK);
		bgNoteLane.screenCenter(X);
		bgNoteLane.alpha = 0;
		add(bgNoteLane);

		bgNoteLane.cameras = [camHUD];

		strumLineNotes = new FlxTypedGroup<StrumArrow>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<StrumArrow>();
		p2Strums = new FlxTypedGroup<StrumArrow>();

		// startCountdown();

		Conductor.checkFakeCrochet(SONG.bpm);
		generateSong(SONG.song);

		// this is dumb
		bruhZoom = defaultCamZoom;
		zoomin = defaultCamZoom + 0.3;

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);
		cameraPosition = new FlxObject(0, 0, 1, 1);

		switch (FlxG.save.data.cameraStartFocus)
		{
			case 0:
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				camFollow.x += dad.charCamPos[0];
				camFollow.y += dad.charCamPos[1];
			case 1:
				camFollow.setPosition(gf.getMidpoint().x, gf.getMidpoint().y);
			case 2:
				camFollow.setPosition(boyfriend.getMidpoint().x + 150, boyfriend.getMidpoint().y - 100);
				camFollow.x -= boyfriend.charCamPos[0];
				camFollow.y += boyfriend.charCamPos[1];
		}

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);
		add(cameraPosition);
		var followLerp:Float = CDevConfig.utils.bound((0.16 / (FlxG.save.data.fpscap / 60)), 0, 1);
		if (!isModStage){
			if (Stage.USECUSTOMFOLLOWLERP){
				followLerp = Stage.FOLLOW_LERP;
			}
		}

		FlxG.camera.follow(camFollow, LOCKON, followLerp);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		cacheSounds();

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);

		iconP2 = new HealthIcon(dad.healthIcon, false);

		healthBarBG = new FlxSprite(0, (FlxG.height * 0.85) + 20).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 80;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.scale.x = 1.1;
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int((healthBarBG.width * healthBarBG.scale.x) - 8),
			Std.int(healthBarBG.height - 8), this, 'healthLerp', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.numDivisions = 3000;
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthBarColors[0], dad.healthBarColors[1], dad.healthBarColors[2]),
			FlxColor.fromRGB(boyfriend.healthBarColors[0], boyfriend.healthBarColors[1], boyfriend.healthBarColors[2]));
		// healthBar
		add(healthBar);

		healthBar.screenCenter(X);

		iconP1.y = healthBar.y - (iconP1.height / 2);
		iconP2.y = healthBar.y - (iconP2.height / 2);

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 18);
		scoreTxt.setFormat(config.uiTextFont, 16, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		scoreTxt.borderSize = 1.1;
		scoreTxt.scrollFactor.set();
		if (FlxG.save.data.downscroll)
			scoreTxt.y = healthBarBG.y + 43;
		// scoreTxt.antialiasing = FlxG.save.data.antialiasing;

		bgScore = new FlxSprite(scoreTxt.x, scoreTxt.y).makeGraphic(500, 500, FlxColor.BLACK);
		bgScore.alpha = 0.3;

		// songPositionshit
		var songPosBGWIDTH:Float = 0;
		var songPosBGHEIGHT:Float = 0;

		songPosBG = new FlxSprite(0, 20).loadGraphic(Paths.image('healthBar'));
		songPosBGWIDTH = songPosBG.width * 0.8;
		songPosBGHEIGHT = songPosBG.height;
		songPosBG.setGraphicSize(Std.int(songPosBG.width * 0.6), Std.int(songPosBG.height));
		songPosBG.screenCenter(X);
		songPosBG.antialiasing = FlxG.save.data.antialiasing;
		songPosBG.scrollFactor.set();
		songPosBG.visible = false;
		add(songPosBG);

		if (FlxG.save.data.downscroll)
			songPosBG.y = FlxG.height * 0.9 + 35;

		songPosBGspr = new FlxSprite(songPosBG.x, songPosBG.y).makeGraphic(Std.int(songPosBGWIDTH), Std.int(songPosBGHEIGHT), FlxColor.BLACK);
		songPosBGspr.antialiasing = FlxG.save.data.antialiasing;
		songPosBGspr.screenCenter(X);
		songPosBGspr.alpha = 0;

		songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBGWIDTH - 8), Std.int(songPosBGHEIGHT - 8), this,
			'songPercent', 0, 1);
		songPosBar.numDivisions = 1000;
		songPosBar.scrollFactor.set();
		songPosBar.screenCenter(X);
		songPosBar.antialiasing = FlxG.save.data.antialiasing;
		songPosBar.createFilledBar(FlxColor.BLACK, config.timeBarColor);
		songPosBar.alpha = 0;

		songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20, songPosBG.y, 0, "", 16);
		// songName.y += 4;
		songName.setFormat(config.uiTextFont, 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songName.scrollFactor.set();
		// songName.screenCenter(X);
		songName.borderSize = 2;

		add(songPosBG);
		add(songPosBGspr);
		add(songPosBar);
		add(songName);

		songPosBG.cameras = [camHUD];
		songPosBGspr.cameras = [camHUD];
		songPosBar.cameras = [camHUD];
		songName.cameras = [camHUD];

		// boob

		add(iconP2);
		add(iconP1);

		add(bgScore);
		add(scoreTxt);

		botplayTxt = new FlxText(0, 0, FlxG.width, "> BOTPLAY <", 32);
		botplayTxt.setFormat(config.uiTextFont, 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		botplayTxt.antialiasing = FlxG.save.data.antialiasing;
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 2;
		botplayTxt.y = 150;
		if (FlxG.save.data.downscroll)
			botplayTxt.y = FlxG.height - 150;
		add(botplayTxt);

		grpNotePresses = new FlxTypedGroup<NotePress>();
		add(grpNotePresses);

		var hmmclicc:NotePress = new NotePress(100, 100, 0);
		grpNotePresses.add(hmmclicc);
		hmmclicc.alpha = 0;

		judgementText = new FlxText(0, 0, 500, '', 18);
		judgementText.setFormat(config.uiTextFont, 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		add(judgementText);

		var allNoteWidth:Float = (160 * 0.7) * 4;
		judgementText.x = (strumXpos + 50 + (allNoteWidth / 2) - (judgementText.width / 2));
		judgementText.bold = true;
		judgementText.borderSize = 1.5;
		var strumYPOS:Float = 70;
		if (FlxG.save.data.downscroll)
		{
			strumYPOS = FlxG.height - 160;
			judgementText.y = strumYPOS + 157 + 25;
		}
		else
		{
			judgementText.y = strumYPOS - 25;
		}
		judgementText.alpha = 0;

		var engineWM:FlxText;
		engineWM = new FlxText(0, 0, MainMenuState.coreEngineText + (FlxG.save.data.testMode ? ' - [TESTMODE]' : ''), 20);
		engineWM.y -= 3;
		engineWM.setFormat(config.uiTextFont, 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		engineWM.scrollFactor.set();
		// engineWM.screenCenter(X);
		engineWM.borderSize = 1.5;
		engineWM.setPosition(20, FlxG.height - engineWM.height - 20);
		if (FlxG.save.data.engineWM)
			add(engineWM);

		engineWM.antialiasing = FlxG.save.data.antialiasing;

		judgementText.cameras = [camHUD];

		bgScore.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		grpNotePresses.cameras = [config.noteImpactsCamera];

		if (FlxG.save.data.engineWM)
			engineWM.cameras = [camHUD];

		botplayTxt.cameras = [camHUD];

		numGroup = new FlxTypedGroup<FlxSprite>();
		numGroup.cameras = [config.ratingSpriteCamera];
		add(numGroup);

		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					introCutscene();
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'ugh', 'guns', 'stress':
					tankIntro();
				default:
					if (intro_cutscene_script != null)
					{
						introCutscene();
					}
					else
					{
						startCountdown();
					}
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
		scripts.executeFunc('postCreate', []);
	}

	// tank Week
	var prevCamZoom:Float = 0; // used on all tank week songs
	var tankmanSprite:FlxSprite; // used on all tank week songs
	var distorto:FlxSound;

	// ugh
	var tankmanTalk1Audio:FlxSound;
	var tankmanTalk2Audio:FlxSound;
	var bfBeep:FlxSound;
	var animPhase:Int = 0;
	var tankmanSpriteOffset:Array<Dynamic> = [
		[0, 5], // talk
		[35, 15] // talk2
	];
	// guns
	var tankmanTalkAudio:FlxSound;

	// stress
	var tankmanTalk1:FlxSprite;
	var tankmanTalk2:FlxSprite;
	var gfTurn1:FlxSprite;
	var gfTurn2:FlxSprite;
	var gfTurn3:FlxSprite;
	var gfTurn4:FlxSprite;
	var gfTurn5:FlxSprite;
	var audio:FlxSound;
	var bf:FlxSprite;
	var ggf:FlxSprite;

	function tankIntro()
	{
		switch (SONG.song.toLowerCase())
		{
			case 'ugh':
				prevCamZoom = defaultCamZoom;
				defaultCamZoom = 1.1;
				FlxG.camera.zoom = defaultCamZoom;
				camHUD.visible = false;
				// FlxG.sound.playMusic(Paths.music('DISTORTO', 'week7'), 0.6);
				dad.visible = false;

				distorto = FlxG.sound.play(Paths.music("DISTORTO", 'week7'));
				distorto.pause();

				tankmanSprite = new FlxSprite(dad.x, dad.y);
				tankmanSprite.frames = Paths.getSparrowAtlas('cutscenes/ugh', 'week7');
				tankmanSprite.antialiasing = FlxG.save.data.antialiasing;
				tankmanSprite.animation.addByPrefix("talk", "TANK TALK 1 P1", 24, false);
				tankmanSprite.animation.addByPrefix("talkk", "TANK TALK 1 P2", 24, false);
				add(tankmanSprite);

				tankmanTalk1Audio = FlxG.sound.play(Paths.sound("wellWellWell", 'week7'));
				tankmanTalk1Audio.pause();

				tankmanTalk2Audio = FlxG.sound.play(Paths.sound("killYou", 'week7'));
				tankmanTalk2Audio.pause();

				bfBeep = FlxG.sound.play(Paths.sound("bfBeep", 'week7'));
				bfBeep.pause();

				distorto.fadeIn(5, 0, 0.4);
				distorto.play();
				inCutscene = true;
			case 'guns':
				prevCamZoom = defaultCamZoom;
				defaultCamZoom = 1;
				camHUD.visible = false;
				dad.visible = false;
				distorto = FlxG.sound.play(Paths.music("DISTORTO", 'week7'), 0.6);
				distorto.pause();

				tankmanTalkAudio = FlxG.sound.play(Paths.sound("tankSong2", 'week7'));
				tankmanTalkAudio.pause();

				tankmanSprite = new FlxSprite(dad.x, dad.y);
				tankmanSprite.frames = Paths.getSparrowAtlas('cutscenes/guns', 'week7');
				tankmanSprite.antialiasing = FlxG.save.data.antialiasing;
				tankmanSprite.animation.addByPrefix("talk", "TANK TALK 2", 24, false);
				tankmanSprite.offset.set(0, 10);

				add(tankmanSprite);

				distorto.fadeIn(5, 0, 0.4);
				distorto.play();
				tankmanTalkAudio.play();
				tankmanSprite.animation.play("talk");
				inCutscene = true;
			case 'stress': // high memory usage moment
				cleanCache();
				gf.visible = false;
				dad.visible = false;
				camHUD.visible = false;

				prevCamZoom = PlayState.defaultCamZoom;
				defaultCamZoom = 1;

				tankmanTalk1 = new FlxSprite(dad.x, dad.y);
				tankmanTalk1.frames = Paths.getSparrowAtlas('cutscenes/stressCutscene/stress', 'week7');
				tankmanTalk1.antialiasing = FlxG.save.data.antialiasing;
				tankmanTalk1.animation.addByPrefix("talk", "TANK TALK 3 P1 UNCUT", 24, false);
				tankmanTalk1.animation.play("talk");
				tankmanTalk1.offset.set(93, 33);

				tankmanTalk2 = new FlxSprite(dad.x, dad.y);
				tankmanTalk2.frames = Paths.getSparrowAtlas('cutscenes/stressCutscene/stress2', 'week7');
				tankmanTalk2.antialiasing = FlxG.save.data.antialiasing;
				tankmanTalk2.animation.addByPrefix("talk", "TANK TALK 3 P2 UNCUT", 24, false);
				tankmanTalk2.animation.play("talk");
				tankmanTalk2.offset.set(4, 28);

				ggf = new FlxSprite(gf.x, gf.y);
				ggf.frames = Paths.getSparrowAtlas('characters/gfTankmen', 'shared');
				ggf.offset.set(99 * 1.1, -129 * 1.1);
				ggf.scrollFactor.set(gf.scrollFactor.x, gf.scrollFactor.y);
				ggf.animation.addByPrefix('dance', "GF Dancing at Gunpoint", 24, true);
				ggf.antialiasing = FlxG.save.data.antialiasing;
				ggf.animation.play('dance');

				gfTurn1 = new FlxSprite(400, 130);
				gfTurn1.frames = Paths.getSparrowAtlas('cutscenes/stressCutscene/gf-turn-1', 'week7');
				gfTurn1.antialiasing = FlxG.save.data.antialiasing;
				gfTurn1.animation.addByPrefix("turn", "GF STARTS TO TURN PART 1", 24, true);
				gfTurn1.animation.play("turn");
				gfTurn1.scrollFactor.set(gf.scrollFactor.x, gf.scrollFactor.y);
				gfTurn1.offset.set(124 * 1.1 + 1, 67 * 1.1 + 1);

				gfTurn2 = new FlxSprite(400, 130);
				gfTurn2.frames = Paths.getSparrowAtlas('cutscenes/stressCutscene/gf-turn-2', 'week7');
				gfTurn2.antialiasing = FlxG.save.data.antialiasing;
				gfTurn2.animation.addByPrefix("turn", "GF STARTS TO TURN PART 2", 24, true);
				gfTurn2.animation.play("turn");
				gfTurn2.scrollFactor.set(gf.scrollFactor.x, gf.scrollFactor.y);
				gfTurn2.offset.set(326 * 1.1 + 4, 468 * 1.1 + 5);

				gfTurn3 = new FlxSprite(400, 130);
				gfTurn3.frames = Paths.getSparrowAtlas('cutscenes/stressCutscene/pico-arrives-1', 'week7');
				gfTurn3.antialiasing = FlxG.save.data.antialiasing;
				gfTurn3.animation.addByPrefix("turn", "PICO ARRIVES PART 1", 24, true);
				gfTurn3.animation.play("turn");
				gfTurn3.scrollFactor.set(gf.scrollFactor.x, gf.scrollFactor.y);
				gfTurn3.offset.set(228 * 1.1, 227 * 1.1);

				gfTurn4 = new FlxSprite(400, 130);
				gfTurn4.frames = Paths.getSparrowAtlas('cutscenes/stressCutscene/pico-arrives-2', 'week7');
				gfTurn4.antialiasing = FlxG.save.data.antialiasing;
				gfTurn4.animation.addByPrefix("turn", "PICO ARRIVES PART 2", 24, true);
				gfTurn4.animation.play("turn");
				gfTurn4.scrollFactor.set(gf.scrollFactor.x, gf.scrollFactor.y);
				gfTurn4.offset.set(500 + (342 * 1.1), 500 + (-80 * 1.1));

				gfTurn5 = new FlxSprite(400, 130);
				gfTurn5.frames = Paths.getSparrowAtlas('cutscenes/stressCutscene/pico-arrives-3', 'week7');
				gfTurn5.antialiasing = FlxG.save.data.antialiasing;
				gfTurn5.animation.addByPrefix("turn", "PICO ARRIVES PART 3", 24, true);
				gfTurn5.animation.play("turn");
				gfTurn5.scrollFactor.set(gf.scrollFactor.x, gf.scrollFactor.y);
				gfTurn5.offset.set(500 + (312 * 1.1) + 1, 500 + (-265 * 1.1) - 7);
				gfTurn5.visible = true;

				bf = new FlxSprite(boyfriend.x, boyfriend.y).loadGraphic(Paths.image('cutscenes/stressCutscene/bf', 'week7'));
				bf.offset.set(boyfriend.offset.x, boyfriend.offset.y);
				bf.antialiasing = true;

				boyfriend.visible = false;

				add(tankmanTalk1);
				add(tankmanTalk2);
				add(bf);
				insert(members.indexOf(gf), ggf);
				insert(members.indexOf(gf), gfTurn1);
				insert(members.indexOf(gf), gfTurn2);
				insert(members.indexOf(gf), gfTurn3);
				insert(members.indexOf(gf), gfTurn4);
				insert(members.indexOf(gf), gfTurn5);

				audio = FlxG.sound.play(Paths.sound('stressCutscene', 'week7'));
				inCutscene = true;
		}
	}

	function dadGFCheck()
	{
		if (dad.curCharacter.startsWith('gf'))
		{
			gf.visible = false;
		}
		else
		{
			gf.visible = true;
		}
	}

	function introCutscene()
	{
		switch (SONG.song.toLowerCase())
		{
			case "winter-horrorland":
				var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				add(blackScreen);
				blackScreen.scrollFactor.set();
				camHUD.visible = false;

				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					remove(blackScreen);
					FlxG.camera.flash(FlxColor.RED);
					FlxG.sound.play(Paths.sound('Lights_Turn_On'));
					camFollow.y = -2050;
					camFollow.x += 200;
					FlxG.camera.focusOn(camFollow.getPosition());
					FlxG.camera.zoom = 1.5;

					new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						camHUD.visible = true;
						remove(blackScreen);
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								startCountdown();
							}
						});
					});
				});
			default:
				inCutscene = true;
				currentCutscene = "intro";

				intro_cutscene_script.setVariable("startSong", function()
				{
					inCutscene = false;
					intro_cutscene_script.executeFunc("introEnd", []);
					startCountdown();
				});

				intro_cutscene_script.executeFunc("introStart", []);
				intro_cutscene_script.executeFunc("postIntro", []);
		}
	}

	function initCharPositions()
	{
		switch (SONG.player1)
		{
			// case 'bf', 'bf-car', 'bf-cscared', 'bf-christmas', 'bf-pixel':
			// BFXPOS = 770;
			// BFYPOS = 450;
			case "spooky":
				BFYPOS += 200;
			case "monster":
				BFYPOS += 100;
			case 'monster-christmas':
				BFYPOS += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				BFYPOS += 300;
			case 'parents-christmas':
				BFXPOS -= 500;
			case 'senpai':
				BFXPOS += 150;
				BFYPOS += 360;
			case 'senpai-angry':
				BFXPOS += 150;
				BFYPOS += 360;
			case 'spirit':
				BFXPOS -= 150;
				BFYPOS += 100;
		}
		switch (SONG.player2)
		{
			case 'bf', 'bf-car', 'bf-cscared', 'bf-christmas':
				DADYPOS = 450;
			case "spooky":
				DADYPOS += 200;
			case "monster":
				DADYPOS += 100;
			case 'monster-christmas':
				DADYPOS += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				DADYPOS += 300;
			case 'parents-christmas':
				DADXPOS -= 500;
			case 'senpai':
				DADXPOS += 150;
				DADYPOS += 360;
			case 'senpai-angry':
				DADXPOS += 150;
				DADYPOS += 360;
			case 'spirit':
				DADXPOS -= 150;
				DADYPOS += 100;
			case 'bf-pixel':
				DADYPOS = 450;
				if (SONG.song.toLowerCase() == 'mod-test')
				{
					DADXPOS = 320;
					DADYPOS = 600;
				}
		}
	}

	public static var instantEndSong:Bool = false;

	function camPosInit()
	{
		switch (SONG.player2)
		{
			case 'senpai', 'senpai-angry', 'spirit':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		switch (SONG.player1)
		{
			case 'senpai', 'senpai-angry', 'spirit':
				camPos.set(boyfriend.getGraphicMidpoint().x + 300, boyfriend.getGraphicMidpoint().y);
		}
	}

	function moveCharToPos(char:Character, ?checkCurCharGF:Bool = false)
	{
		if (checkCurCharGF && char.curCharacter.startsWith('gf'))
		{
			char.setPosition(GFXPOS, GFYPOS);
			char.scrollFactor.set(0.95, 0.95);
		}
		char.x += char.charXYPos[0];
		char.y += char.charXYPos[1];
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					switch (SONG.song.toLowerCase())
					{
						case "thorns":
							add(senpaiEvil);
							senpaiEvil.alpha = 0;
							new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
							{
								senpaiEvil.alpha += 0.15;
								if (senpaiEvil.alpha < 1)
								{
									swagTimer.reset();
								}
								else
								{
									senpaiEvil.animation.play('idle');
									FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
									{
										remove(senpaiEvil);
										remove(red);
										FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
										{
											add(dialogueBox);
											camHUD.visible = true;
										}, true);
									});

									new FlxTimer().start(0.92, function(camMove:FlxTimer)
									{
										FlxTween.tween(senpaiEvil, {x: ((FlxG.width / 2) - (senpaiEvil.width / 2)) + 200}, 2, {ease: FlxEase.backOut});
									});

									new FlxTimer().start(2.30, function(camMove:FlxTimer)
									{
										FlxG.camera.shake(0.030, 5);
									});
									new FlxTimer().start(3.2, function(deadTime:FlxTimer)
									{
										FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
									});
								}
							});
						default:
							add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function cacheSounds()
	{
		// HELL
		var altSuffix:String = '';
		if (isPixel)
			altSuffix = '-pixel';

		CDevConfig.utils.doSoundCaching('hitsound', 'shared');
		CDevConfig.utils.doSoundCaching('missnote1', 'shared');
		CDevConfig.utils.doSoundCaching('missnote2', 'shared');
		CDevConfig.utils.doSoundCaching('missnote3', 'shared');

		CDevConfig.utils.doSoundCaching('intro1' + altSuffix, 'shared');
		CDevConfig.utils.doSoundCaching('intro2' + altSuffix, 'shared');
		CDevConfig.utils.doSoundCaching('intro3' + altSuffix, 'shared');
		CDevConfig.utils.doSoundCaching('introGo' + altSuffix, 'shared');

		if (SONG.song.toLowerCase() == 'winter-horrorland')
			CDevConfig.utils.doSoundCaching('Lights_Shut_off', 'shared');

		if (curStage.toLowerCase() == 'spooky')
		{
			CDevConfig.utils.doSoundCaching('thunder_1', 'shared');
			CDevConfig.utils.doSoundCaching('thunder_2', 'shared');
		}

		if (curStage.toLowerCase() == 'limo')
		{
			CDevConfig.utils.doSoundCaching('carPass0', 'shared');
			CDevConfig.utils.doSoundCaching('carPass1', 'shared');
		}
	}

	var startTimer:FlxTimer;

	public function startCountdown():Void
	{
		camHUD.visible = true;
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		// if (songSpeed != 1)
		// Conductor.updateBPMBasedOnSongSpeed(SONG.bpm, songSpeed);

		Conductor.songPosition = 0;

		Conductor.songPosition -= (Conductor.crochet * 5) + SONG.offset + Conductor.offset;

		Conductor.rawTime = Conductor.songPosition;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.dance();

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";
			var introAudio:Array<String> = ['intro3', 'intro2', 'intro1', 'introGo'];

			switch (SONG.song.toLowerCase())
			{
				case 'thorns':
					introAudio = ['intro3-error', 'intro2-error', 'intro1-error', 'introGo-error'];
				default:
					introAudio = ['intro3', 'intro2', 'intro1', 'introGo'];
			}

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}
			var libshit:String = 'shared';
			if (isPixel)
			{
				introAlts = introAssets.get("school");
				altSuffix = '-pixel';
				libshit = 'week6';
			}

			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play(Paths.sound(introAudio[swagCounter] + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0], libshit));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (isPixel)
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound(introAudio[swagCounter] + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1], libshit));
					set.scrollFactor.set();

					if (isPixel)
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound(introAudio[swagCounter] + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2], libshit));
					go.scrollFactor.set();

					if (isPixel)
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound(introAudio[swagCounter] + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');

			scripts.executeFunc('onCountdown', [swagCounter]);
		}, 5);

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
			checkPlayerStrum();
		}
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		camHUD.visible = true;
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);

		// FlxG.sound.music.time += SONG.offset + Conductor.offset;
		if (songSpeed == 1)
			FlxG.sound.music.onComplete = endSong;
		else
			FlxG.sound.music.onComplete = function()
			{
			};

		vocals.play();
		// vocals_opponent.play();

		FlxTween.tween(bgNoteLane, {alpha: 0.5}, Conductor.crochet / 1000, {ease: FlxEase.linear});
		FlxTween.tween(songPosBGspr, {alpha: 1}, Conductor.crochet / 1000, {ease: FlxEase.linear});
		FlxTween.tween(songPosBar, {alpha: 1}, Conductor.crochet / 1000, {ease: FlxEase.linear});
		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (songSpeed != 1)
		{
			// Conductor.updateBPMBasedOnSongSpeed(SONG.bpm, songSpeed);
			// Conductor.crochet = ((60 / (SONG.bpm) * 1000)) / songSpeed;
			// Conductor.stepCrochet = Conductor.crochet / 4;
		}

		// Updating Discord Rich Presence (with Time Left)
		if (Main.discordRPC)
			DiscordClient.changePresence(detailsText, daRPCInfo, iconRPC, true, songLength);
		#end

		/*#if cpp
			if (FlxG.sound.music != null) {
				@:privateAccess
				{
					AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, AL.PITCH, songSpeed);
					if (vocals.playing)
						AL.sourcef(vocals._channel.__source.__backend.handle, AL.PITCH, songSpeed);
				}
			}
			#end */

		scripts.executeFunc('onStartSong', []);
	}

	var debugNum:Int = 0;

	public static var eventNames:Array<String> = [];

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;
		if (SONG.needsVoices)
		{
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
			// vocals_opponent = new FlxSound().loadEmbedded(Paths.voice_opponent(PlayState.SONG.song));
		}
		else
		{
			vocals = new FlxSound();
			// vocals_opponent = new FlxSound();
		}

		FlxG.sound.list.add(vocals);
		// FlxG.sound.list.add(vocals_opponent);

		notes = new FlxTypedGroup<Note>();
		add(notes);
		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var crapNote:Note;
		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		for (i in 0...ChartEvent.builtInEvents.length)
		{
			eventNames.push(ChartEvent.builtInEvents[i][0]);
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				if (songNotes[1] > -1)
				{
					var daStrumTime:Float = songNotes[0] + SONG.offset + Conductor.offset;
					var daNoteData:Int = Std.int(songNotes[1] % 4);

					var gottaHitNote:Bool = section.mustHitSection;

					if (songNotes[1] > 3)
						gottaHitNote = !section.mustHitSection;

					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;

					if (unspawnNotes.length > 0)
						crapNote = oldNote;
					else
						crapNote = null;

					if (randomNote)
					{
						var data:Int = FlxG.random.int(0, 8) % 4;
						if (crapNote != null)
							if (data == crapNote.noteData)
								data = FlxG.random.int(0, 8) % 4;

						// FlxG.log.add('noteData: ' + data);

						daNoteData = data;
					}

					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
					swagNote.sustainLength = songNotes[2];
					swagNote.scrollFactor.set(0, 0);

					var susLength:Float = swagNote.sustainLength;

					susLength = susLength / Conductor.stepCrochet;

					unspawnNotes.push(swagNote);

					for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
						if (randomNote && !oldNote.isSustainNote)
							daNoteData = oldNote.noteData;

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);

						sustainNote.mustPress = gottaHitNote;

						if (playingLeftSide)
						{
							sustainNote.mustPress = !gottaHitNote;
						}

						swagNote.noteTrail.push(sustainNote);

						if (sustainNote.mustPress)
							sustainNote.x += FlxG.width / 2; // general offset
					}

					swagNote.mustPress = gottaHitNote;

					if (playingLeftSide)
					{
						swagNote.mustPress = !gottaHitNote;
					}

					if (swagNote.mustPress)
						swagNote.x += FlxG.width / 2; // general offset
				}
			}

			if (section.sectionEvents != null)
			{
				for (songEvents in section.sectionEvents)
				{
					var strm:Float = songEvents[2] + SONG.offset + Conductor.offset;
					var eventName:String = songEvents[0];
					var val1:String = songEvents[3];
					var val2:String = songEvents[4];

					if (!eventNames.contains(eventName))
					{
						var event:ChartEvent = new ChartEvent(strm, 0, false);
						event.mod = fromMod;
						event.EVENT_NAME = eventName;
						event.value1 = val1;
						event.value2 = val2;
						// event.setUpEvent();
						toDoEvents.push(event);
					}
					else
					{
						var event:ChartEvent = new ChartEvent(strm, 0, false);
						event.mod = fromMod;
						event.EVENT_NAME = eventName;
						event.value1 = val1;
						event.value2 = val2;
						toDoEvents.push(event);
					}
				}
			}

			daBeats += 1;
		}

		unspawnNotes.sort(sortByShit);

		if (toDoEvents.length > 1)
		{
			toDoEvents.sort(sortByTime);
		}
		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:ChartEvent, Obj2:ChartEvent):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.time, Obj2.time);
	}

	function sortByID(Obj1:Dynamic, Obj2:Dynamic):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1[1], Obj2[1]);
	}

	private function generateStaticArrows(player:Int):Void
	{
		// animName, animID
		var animXML_static:Array<Dynamic> = [];
		var animXML_pressed:Array<Dynamic> = [];
		var animXML_confirm:Array<Dynamic> = [];

		animXML_static.push(['arrowLEFT', 0]);
		animXML_static.push(['arrowDOWN', 1]);
		animXML_static.push(['arrowUP', 2]);
		animXML_static.push(['arrowRIGHT', 3]);

		animXML_pressed.push(['left press', 0]);
		animXML_pressed.push(['down press', 1]);
		animXML_pressed.push(['up press', 2]);
		animXML_pressed.push(['right press', 3]);

		animXML_confirm.push(['left confirm', 0]);
		animXML_confirm.push(['down confirm', 1]);
		animXML_confirm.push(['up confirm', 2]);
		animXML_confirm.push(['right confirm', 3]);
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:StrumArrow = new StrumArrow(strumXpos, strumLine.y);

			if (isPixel)
			{
				babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels', 'week6'), true, 17, 17);
				babyArrow.animation.add('green', [6]);
				babyArrow.animation.add('red', [7]);
				babyArrow.animation.add('blue', [5]);
				babyArrow.animation.add('purplel', [4]);

				babyArrow.setGraphicSize(Std.int(babyArrow.width * (daPixelZoom - 0.1)));
				babyArrow.updateHitbox();
				babyArrow.antialiasing = false;

				switch (Math.abs(i))
				{
					case 0:
						babyArrow.x += Note.swagWidth * 0;
						babyArrow.animation.add('static', [0]);
						babyArrow.animation.add('pressed', [4, 8], 12, false);
						babyArrow.animation.add('confirm', [12, 16], 24, false);
					case 1:
						babyArrow.x += Note.swagWidth * 1;
						babyArrow.animation.add('static', [1]);
						babyArrow.animation.add('pressed', [5, 9], 12, false);
						babyArrow.animation.add('confirm', [13, 17], 24, false);
					case 2:
						babyArrow.x += Note.swagWidth * 2;
						babyArrow.animation.add('static', [2]);
						babyArrow.animation.add('pressed', [6, 10], 12, false);
						babyArrow.animation.add('confirm', [14, 18], 12, false);
					case 3:
						babyArrow.x += Note.swagWidth * 3;
						babyArrow.animation.add('static', [3]);
						babyArrow.animation.add('pressed', [7, 11], 12, false);
						babyArrow.animation.add('confirm', [15, 19], 24, false);
				}
			}
			else
			{
				if (FlxG.save.data.fnfNotes)
				{
					babyArrow.frames = Paths.getSparrowAtlas('notes/NOTE_assets');
					babyArrow.animation.addByPrefix('purple', animXML_static[0][0]);
					babyArrow.animation.addByPrefix('blue', animXML_static[1][0]);
					babyArrow.animation.addByPrefix('green', animXML_static[2][0]);
					babyArrow.animation.addByPrefix('red', animXML_static[3][0]);

					babyArrow.antialiasing = FlxG.save.data.antialiasing;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', animXML_static[0][0]);
							babyArrow.animation.addByPrefix('pressed', animXML_pressed[0][0], 24, false);
							babyArrow.animation.addByPrefix('confirm', animXML_confirm[0][0], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', animXML_static[1][0]);
							babyArrow.animation.addByPrefix('pressed', animXML_pressed[1][0], 24, false);
							babyArrow.animation.addByPrefix('confirm', animXML_confirm[1][0], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', animXML_static[2][0]);
							babyArrow.animation.addByPrefix('pressed', animXML_pressed[2][0], 24, false);
							babyArrow.animation.addByPrefix('confirm', animXML_confirm[2][0], 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', animXML_static[3][0]);
							babyArrow.animation.addByPrefix('pressed', animXML_pressed[3][0], 24, false);
							babyArrow.animation.addByPrefix('confirm', animXML_confirm[3][0], 24, false);
					}
				}
				else
				{
					babyArrow.frames = Paths.getSparrowAtlas('notes/CDEVNOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = FlxG.save.data.antialiasing;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT-static');
							babyArrow.animation.addByPrefix('pressed', 'arrowLEFT-pressed', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'arrowLEFT-confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN-static');
							babyArrow.animation.addByPrefix('pressed', 'arrowDOWN-pressed', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'arrowDOWN-confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP-static');
							babyArrow.animation.addByPrefix('pressed', 'arrowUP-pressed', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'arrowUP-confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT-static');
							babyArrow.animation.addByPrefix('pressed', 'arrowRIGHT-pressed', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'arrowRIGHT-confirm', 24, false);
					}
				}
			}

			babyArrow.ID = i;

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				if (!FlxG.save.data.downscroll)
				{
					babyArrow.y -= 50;
					babyArrow.alpha = 0;
					FlxTween.tween(babyArrow, {y: babyArrow.y + 50, alpha: 1}, ((Conductor.crochet * 4) / 1000) - 0.1,
						{ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				}
				else
				{
					babyArrow.y += 50;
					babyArrow.alpha = 0;
					FlxTween.tween(babyArrow, {y: babyArrow.y - 50, alpha: 1}, ((Conductor.crochet * 4) / 1000) - 0.1,
						{ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				}
			}

			switch (player)
			{
				case 0:
					p2Strums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.playAnim('static', false);
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			var down:Float = (FlxG.save.data.downscroll ? -1 : 1);
			babyArrow.noteScroll = down;

			if (FlxG.save.data.botplay)
				playerStrums.forEach(function(spr:StrumArrow)
				{
					spr.centerOffsets();
				});

			p2Strums.forEach(function(spr:StrumArrow)
			{
				spr.centerOffsets();
			});
			strumLineNotes.add(babyArrow);
		}
	}

	function checkPlayerStrum()
	{
		if (!FlxG.save.data.middlescroll)
		{
			var playerLeft:Array<Float> = [0, 0, 0, 0];
			var playerRight:Array<Float> = [0, 0, 0, 0];
			if (playingLeftSide)
			{
				// copying the x position.
				for (i in 0...p2Strums.members.length)
				{
					playerLeft[i] = p2Strums.members[i].x;
				}

				for (i in 0...playerStrums.members.length)
				{
					playerRight[i] = playerStrums.members[i].x;
				}

				// applying the copied x positions.
				for (i in 0...p2Strums.members.length)
				{
					p2Strums.members[i].x = playerRight[i];
				}

				for (i in 0...playerStrums.members.length)
				{
					playerStrums.members[i].x = playerLeft[i];
				}
			}
		}
	}

	function removeStrums()
	{
		playerStrums.clear();
		p2Strums.clear();
		strumLineNotes.clear();
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
				// vocals_opponent.pause();
			}

			if (!inCutscene)
			{
				if (!startTimer.finished)
					startTimer.active = false;
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}
			var followLerp:Float = CDevConfig.utils.bound((0.16 / (FlxG.save.data.fpscap / 60)), 0, 1);
			if (!isModStage){
				if (Stage.USECUSTOMFOLLOWLERP){
					followLerp = Stage.FOLLOW_LERP;
				}
			}
			FlxG.camera.followLerp = followLerp;

			if (!inCutscene)
			{
				if (!startTimer.finished)
					startTimer.active = true;
			}
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				if (Main.discordRPC)
					DiscordClient.changePresence(detailsText, daRPCInfo, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				if (Main.discordRPC)
					DiscordClient.changePresence(detailsText, daRPCInfo, iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	var dotheThing:Bool = false;
	var imhungry:Bool = false;

	function doXPosNoteMove()
	{
		var thee = (Conductor.songPosition / 1000) * (Conductor.bpm / 60);
		if (imhungry)
			for (i in 0...4)
				playerStrums.members[i].x = playerStrums.members[i].x + (Math.sin((thee / 2) * 3.14));

		if (imhungry)
			for (e in 0...4)
				p2Strums.members[e].x = p2Strums.members[e].x + (Math.sin((thee / 2) * 3.14));
	}

	function doSwagNoteTests()
	{
		var the = (Conductor.songPosition / 1000) * (Conductor.bpm / 60);
		if (dotheThing)
			for (i in 0...4)
				playerStrums.members[i].y = playerStrums.members[i].y + (Math.cos((the / 2) * 3.14));

		if (dotheThing)
			for (e in 0...4)
				p2Strums.members[e].y = p2Strums.members[e].y + (Math.cos((the / 2) * 3.14));
	}

	public static function addNewTraceKey(key:Dynamic)
	{
		TraceLog.addLogData(key);
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				if (Main.discordRPC)
					DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true,
						songLength - Conductor.songPosition);
			}
			else
			{
				if (Main.discordRPC)
					DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (FlxG.save.data.autoPause)
		{
			if (health > 0 && !paused)
			{
				if (Main.discordRPC)
					DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();
		// vocals_opponent.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		// vocals_opponent.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var testFlaot:Float = 0;
	var crap:Float = 0;
	var p1Lerp:Float;
	var p2Lerp:Float;
	var bgL:Bool = false;
	var songStarted = false;

	// ugh
	var elapsedTimeShit:Float = 0;

	// stress
	var prevFolLerp:Float = 0;
	var isHug:Bool = false;

	var timeShit:Float = 0;
	var timeS:Float = 0;

	var followhuh:Bool = false;
	var xfp:Float = 0;
	var yfp:Float = 0;

	override public function update(elapsed:Float)
	{
		scripts.executeFunc('update', [elapsed]);

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
			case 'tank':
				if (songStarted)
					moveTank(elapsed);
		}

		if (isStoryMode)
		{
			if (inCutscene)
			{
				switch (SONG.song.toLowerCase())
				{
					case 'ugh':
						if (tankmanSprite != null)
						{
							switch (animPhase)
							{
								case 0:
									if (tankmanSprite.animation.curAnim == null)
									{
										tankmanSprite.animation.play("talk");
										tankmanSprite.offset.set(tankmanSpriteOffset[0][0], tankmanSpriteOffset[0][1]);
										tankmanTalk1Audio.play();
										camFollow.setPosition(dad.getMidpoint().x + 150 + dad.charCamPos[0], dad.getMidpoint().y - 100 + dad.charCamPos[1]);
									}
									if (tankmanSprite.animation.curAnim.finished) animPhase++;
								case 1:
									elapsedTimeShit += elapsed;
									camFollow.setPosition(boyfriend.getMidpoint().x - 100 + boyfriend.charCamPos[0],
										boyfriend.getMidpoint().y - 100 + boyfriend.charCamPos[1]);
									if (elapsedTimeShit > 1)
									{
										bfBeep.play();
										boyfriend.playAnim("singUP");
										elapsedTimeShit = 0;
										animPhase++;
									}
								case 2:
									elapsedTimeShit += elapsed;
									if (!bfBeep.playing)
									{
										boyfriend.playAnim("idle");
										elapsedTimeShit = 0;
										animPhase++;
									}
								case 3:
									elapsedTimeShit += elapsed;
									if (elapsedTimeShit > 1)
									{
										elapsedTimeShit = 0;
										animPhase++;
										tankmanSprite.animation.curAnim = null;
									}
								case 4:
									if (tankmanSprite.animation.curAnim == null)
									{
										tankmanSprite.animation.play("talkk");
										tankmanSprite.offset.set(tankmanSpriteOffset[1][0], tankmanSpriteOffset[1][1]);
										tankmanTalk2Audio.play();
										camFollow.setPosition(dad.getMidpoint().x + 150 + dad.charCamPos[0], dad.getMidpoint().y - 100 + dad.charCamPos[0]);
									}
									if (tankmanSprite.animation.curAnim.finished)
									{
										animPhase++;
									}
								case 5:
									distorto.fadeOut(0.5, 0, function(aa:FlxTween)
									{
										distorto.stop();
									});
									defaultCamZoom = prevCamZoom;

									startCountdown();

									dad.visible = true;
									remove(tankmanSprite);
									tankmanSprite.destroy();

									bfBeep.destroy();
									// done
							}
						}
					case 'guns':
						camFollow.setPosition(dad.getMidpoint().x + 150 + dad.charCamPos[0], PlayState.dad.getMidpoint().y - 100 + dad.charCamPos[1]);
						tankmanSprite.animation.curAnim.curFrame = Std.int(tankmanTalkAudio.time / tankmanTalkAudio.length * tankmanSprite.animation.curAnim.frames.length);

						if (tankmanTalkAudio.time > 4150)
						{
							gf.playAnim("sad");
							FlxG.camera.zoom = defaultCamZoom
								+ (Math.sin(FlxEase.quartOut(FlxMath.bound((tankmanTalkAudio.time - 4150) / 1500, 0, 1)) * Math.PI) * 0.1);
						}
						if (tankmanSprite.animation.curAnim.finished || !tankmanTalkAudio.playing)
						{
							remove(tankmanSprite);
							tankmanSprite.destroy();
							distorto.fadeOut(0.5, 0, function(aa:FlxTween)
							{
								distorto.stop();
							});
							defaultCamZoom = prevCamZoom;
							dad.visible = true;
							startCountdown();
						}
					case 'stress':
						// cam
						if (audio.time < 14750)
						{
							camFollow.setPosition(dad.getMidpoint().x + 150 + dad.charCamPos[0], dad.getMidpoint().y - 100 + dad.charCamPos[1]);
						}
						else if (audio.time < 17237)
						{
							var t = (audio.time - 14750) / (17237 - 14750);
							var gfCamPos = gf.getMidpoint();
							camFollow.setPosition(gfCamPos.x - 100, gfCamPos.y);
							FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, 1.25, FlxEase.quadInOut(t));
						}
						else if (audio.time < 20000)
						{
							defaultCamZoom = prevCamZoom;
							FlxG.camera.zoom = prevCamZoom;
						}
						else if (audio.time < 31250)
						{
							camFollow.setPosition(dad.getMidpoint().x + 150 + dad.charCamPos[0] + 200, dad.getMidpoint().y - 100 + dad.charCamPos[1]);
						}
						else if (audio.time < 32250)
						{
							foregroundSprites.forEach(function(spr:FlxSprite)
							{
								spr.visible = false;
							});
							boyfriend.playAnim("singUPmiss");
							camFollow.setPosition(boyfriend.getMidpoint().x, boyfriend.getMidpoint().y);
							if (prevFolLerp == 0)
							{
								prevFolLerp = FlxG.camera.followLerp;
								FlxG.camera.followLerp = 1;
							}
							FlxG.camera.zoom = 1.25;
						}
						else
						{
							foregroundSprites.forEach(function(spr:FlxSprite)
							{
								spr.visible = true;
							});
							boyfriend.dance();
							boyfriend.animation.curAnim.curFrame = boyfriend.animation.curAnim.frames.length - 1;

							FlxG.camera.followLerp = 1;
							camFollow.setPosition(dad.getMidpoint().x + 150 + dad.charCamPos[0] + 200, dad.getMidpoint().y - 100 + dad.charCamPos[1]);
							FlxG.camera.zoom = defaultCamZoom;
						}

						if (audio.playing)
						{
							if (audio.time > 21248)
							{
								ggf.visible = false;
								gfTurn1.visible = false;
								gfTurn2.visible = false;
								gfTurn3.visible = false;
								gfTurn4.visible = false;
								gfTurn5.visible = false;

								gf.visible = true;
								gf.dance();
							}
							else if (audio.time > 19620)
							{
								ggf.visible = false;
								gfTurn1.visible = false;
								gfTurn2.visible = false;
								gfTurn3.visible = false;
								gfTurn4.visible = false;
								gfTurn5.visible = true;

								var t = audio.time - 19620;
								gfTurn5.animation.curAnim.curFrame = Std.int(t / (21248 - 19620) * gfTurn5.animation.curAnim.frames.length);
							}
							else if (audio.time > 18245)
							{
								ggf.visible = false;
								gfTurn1.visible = false;
								gfTurn2.visible = false;
								gfTurn3.visible = false;
								gfTurn4.visible = true;
								gfTurn5.visible = false;

								var t = audio.time - 18245;
								gfTurn4.animation.curAnim.curFrame = Std.int(t / (19620 - 18245) * 32);
							}
							else if (audio.time > 17237)
							{
								ggf.visible = false;
								gfTurn1.visible = false;
								gfTurn2.visible = false;
								gfTurn3.visible = true;
								gfTurn4.visible = false;
								gfTurn5.visible = false;
								bf.visible = false;
								boyfriend.visible = true;
								if (isHug)
								{
									boyfriend.playAnim("bfCatch");
									isHug = false;
								}
								else
								{
									if (boyfriend.animation.curAnim.finished)
									{
										boyfriend.holdTimer = 20000;
										boyfriend.dance();
										boyfriend.animation.curAnim.curFrame = boyfriend.animation.curAnim.frames.length - 1;
									}
								}

								var t = audio.time - 17237;
								gfTurn3.animation.curAnim.curFrame = Std.int(t / (18245 - 17237) * gfTurn3.animation.curAnim.frames.length);
							}
							else if (audio.time > 16284)
							{
								ggf.visible = false;
								gfTurn1.visible = false;
								gfTurn2.visible = true;
								gfTurn3.visible = false;
								gfTurn4.visible = false;
								gfTurn5.visible = false;

								var t = audio.time - 16284;
								gfTurn2.animation.curAnim.curFrame = Std.int(t / (17237 - 16284) * gfTurn2.animation.curAnim.frames.length);
							}
							else if (audio.time > 14750)
							{
								ggf.visible = false;
								gfTurn1.visible = true;
								gfTurn2.visible = false;
								gfTurn3.visible = false;
								gfTurn4.visible = false;
								gfTurn5.visible = false;

								var t = audio.time - 14750;
								gfTurn1.animation.curAnim.curFrame = Std.int(t / (16284 - 14750) * gfTurn1.animation.curAnim.frames.length);
							}
							else
							{
								ggf.visible = true;
								gfTurn1.visible = false;
								gfTurn2.visible = false;
								gfTurn3.visible = false;
								gfTurn4.visible = false;
								gfTurn5.visible = false;
							}
						}

						// takn
						if (audio.time < 17042)
						{
							tankmanTalk1.visible = true;
							tankmanTalk2.visible = false;
							tankmanTalk1.animation.curAnim.curFrame = Std.int(audio.time / 17042 * tankmanTalk1.animation.curAnim.frames.length);
						}
						else
						{
							if (audio.time > 19250)
							{
								tankmanTalk1.visible = false;
								tankmanTalk2.visible = true;
								tankmanTalk2.animation.curAnim.curFrame = Std.int((audio.time - 19250) / (361 / 24 * 1000) * tankmanTalk2.animation.curAnim.frames.length);
							}
						}

						if (!audio.playing)
						{
							gf.visible = true;
							dad.visible = true;

							var itemToDelete = [tankmanTalk1, tankmanTalk2, gfTurn1, gfTurn2, gfTurn3, gfTurn4, gfTurn5, ggf];
							for (i in itemToDelete)
							{
								remove(i);
								i.destroy();
							}
							cleanCache();
							FlxG.camera.followLerp = prevFolLerp;
							startCountdown();
						}
					default:
						switch (currentCutscene)
						{
							case "intro":
								if (intro_cutscene_script != null)
								{
									intro_cutscene_script.executeFunc("update", [elapsed]);
								}
							case "outro":
								if (outro_cutscene_script != null)
								{
									outro_cutscene_script.executeFunc("update", [elapsed]);
								}
						}
				}
			}
		}
		#if cpp
		if (FlxG.sound.music.playing)
			@:privateAccess
		{
			AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, AL.PITCH, songSpeed);
			if (vocals.playing)
				AL.sourcef(vocals._channel.__source.__backend.handle, AL.PITCH, songSpeed);

			// if (vocals_opponent.playing)
			//	AL.sourcef(vocals_opponent._channel.__source.__backend.handle, AL.PITCH, songSpeed);

			if (songSpeed != 1)
				if (FlxG.sound.music._channel.__source.__backend.getCurrentTime() == (FlxG.sound.music._channel.__source.__backend.getLength() - 1))
					endSong();
		}
		#end

		super.update(elapsed);
		if (FlxG.save.data.showTraceLogAt == 1)
		{
			if (traceWindow != null)
			{
				// if (FlxG.mouse.overlaps(traceWindow))
				//
				if (FlxG.mouse.overlaps(traceWindow, camTrace))
				{
					if (FlxG.mouse.pressed)
					{
						xfp = FlxG.mouse.getPositionInCameraView(camTrace).x - (traceWindow.PANEL_BG.width / 2);
						yfp = FlxG.mouse.getPositionInCameraView(camTrace).y - (traceWindow.PANEL_BG.height / 2);
						traceWindow.PANEL_BG.setPosition(xfp, yfp);
						followhuh = true;
						if (FlxG.save.data.testMode)
							trace(followhuh);
					}
					else
					{
						followhuh = false;
					}
				}
				// }
			}
		}

		if (generatedMusic)
		{
			if (songStarted && !endingSong)
			{
				if (unspawnNotes.length == 0 && FlxG.sound.music.length - Conductor.songPosition <= 100)
				{
					endSong();
				}
			}
			if (startedCountdown && canPause && !endingSong)
			{
				// if (FlxG.sound.music.length - Conductor.songPosition <= 20)
				// {
				//	// time = FlxG.sound.music.length;
				//	endSong();
				// }
			}
		}

		ratingText = RatingsCheck.getRating(convertedAccuracy)
			+ " ("
			+ RatingsCheck.getRatingText(convertedAccuracy)
			+ (convertedAccuracy == 0 ? ')' : ", " + RatingsCheck.getRankText() + ")");

		// scoreTxt.text = 'Score: ' + songScore + ' // Misses: ' + misses + ' // Accuracy: ' + RatingsCheck.fixFloat(convertedAccuracy, 2) + "% "
		//	+ "// Rank: " + ratingText;

		if (!FlxG.save.data.botplay)
		{
			if (FlxG.save.data.fullinfo)
				scoreTxt.text = '${config.missesText}: '
					+ misses
					+ ' // ${config.scoreText}: '
					+ songScore
					+ ' // ${config.accuracyText}: '
					+ RatingsCheck.fixFloat(convertedAccuracy, 2)
					+ "% "
					+ "("
					+ ratingText
					+ ')'
					+ (FlxG.save.data.healthCounter ? ' // Health: ' + Math.floor(healthBarPercent) + '%' : '');
			else
				scoreTxt.text = 'Score: ' + songScore;
		}
		else
		{
			if (FlxG.save.data.fullinfo)
				scoreTxt.text = '${config.missesText}: '
					+ misses
					+ ' // ${config.scoreText}: '
					+ songScore
					+ ' // ${config.accuracyText}: '
					+ RatingsCheck.fixFloat(convertedAccuracy, 2)
					+ "% (Botplay)"
					+ (FlxG.save.data.healthCounter ? ' // Health: ' + Math.floor(healthBarPercent) + '%' : '');
			else
				scoreTxt.text = 'Score: ' + songScore + " (Botplay)";
		}

		daRPCInfo = '${config.scoreText}: ' + songScore + " | " + '${config.missesText}: ' + misses + ' | ' + '${config.accuracyText}: '
			+ RatingsCheck.fixFloat(convertedAccuracy, 2) + "% (" + ratingText + ')';

		scoreWidth = Std.int((scoreTxt.size * 0.59) * scoreTxt.text.length);
		// bgScore.setGraphicSize(Std.int(FlxMath.lerp(bgSWidth, bgScore.width, CDevConfig.utils.bound(1 - (elapsed * 7), 0, 1))), Std.int(FlxMath.lerp(bgSHeight, bgScore.height, CDevConfig.utils.bound(1 - (elapsed * 7), 0, 1))));
		bgScore.setGraphicSize(Std.int(scoreWidth + 3), Std.int(scoreTxt.height + 3));
		bgScore.screenCenter(X);
		bgScore.y = scoreTxt.y;
		bgScore.updateHitbox();
		bgScore.visible = scoreTxt.visible;

		if (FlxG.save.data.bgLane && FlxG.save.data.middlescroll)
			bgL = true;
		else
			bgL = false;

		bgNoteLane.visible = bgL;

		if (songStarted)
		{
			if (FlxG.sound.music.playing)
			{
				if (FlxG.save.data.botplay)
				{
					botplayTxt.screenCenter(X);
					crap += SONG.bpm * elapsed;
					botplayTxt.alpha = 1 - Math.sin((3.14 * crap) / SONG.bpm);
					// botplayTxt.alpha = Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * -1.0) * 2.5;
				}
				else
				{
					botplayTxt.screenCenter(X);
					botplayTxt.alpha = 0;
				}
			}
		}
		else
		{
			botplayTxt.screenCenter(X);
			botplayTxt.alpha = 0;
		}

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new substates.PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if desktop
			if (Main.discordRPC)
				DiscordClient.changePresence(detailsPausedText, daRPCInfo, iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			songSpeed = 1.0;
			FlxG.sound.music.pause();
			vocals.pause();
			// vocals_opponent.pause();

			chartingMode = true;
			FlxG.switchState(new states.charter.ChartingState());
			if (FlxG.save.data.showTraceLogAt == 1)
				TraceLog.clearLogData();

			#if desktop
			if (Main.discordRPC)
				DiscordClient.changePresence("Charting Screen", null, null, true);
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconUpdateFunction(elapsed);

		if (FlxG.save.data.middlescroll)
		{
			for (i in 0...p2Strums.length)
			{
				p2Strums.members[i].visible = false;
			}
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		if (FlxG.save.data.testMode) // y e s
		{
			if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.T) // Go to 10 seconds into the future, credit: Shadow Mario#9396
			{
				FlxG.sound.music.pause();
				vocals.pause();
				// vocals_opponent.pause();
				Conductor.songPosition += 10000;
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.strumTime + 800 < Conductor.songPosition)
					{
						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
				for (i in 0...unspawnNotes.length)
				{
					var daNote:Note = unspawnNotes[0];
					if (daNote.strumTime + 800 >= Conductor.songPosition)
					{
						break;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
					daNote.destroy();
				}

				FlxG.sound.music.time = Conductor.songPosition;
				FlxG.sound.music.play();

				vocals.time = Conductor.songPosition;
				vocals.play();

				// vocals_opponent.time = Conductor.songPosition;
				// vocals_opponent.play();
			}

			// instantly end the song
			if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.justPressed.ONE)
				endSong();

			// hide / show the main camera
			if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.justPressed.C)
				FlxG.camera.visible = !FlxG.camera.visible;

			// hide / show the hud camera
			if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.justPressed.P)
				camHUD.visible = !camHUD.visible;

			// note shits
			if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.justPressed.N)
				dotheThing = !dotheThing;

			// note shits
			if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.justPressed.NUMPADEIGHT)
				imhungry = !imhungry;

			// helth
			if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.H)
				health = 0.7;

			// increase your combo
			if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.M)
				combo += 1;

			// increase your misses
			if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.N)
				misses += 1;

			// toggle/disable botplay
			if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.B)
			{
				FlxG.save.data.botplay = !FlxG.save.data.botplay;
			}

			// instant crash the game
			if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT && FlxG.keys.justPressed.SPACE)
			{
				trace("crashing the game");
				var b:BitmapData = null;
				b.clone();
			}

			// pause stuff
			if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.ENTER)
			{
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				openSubState(new substates.PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if desktop
				if (Main.discordRPC)
					DiscordClient.changePresence(detailsPausedText, daRPCInfo, iconRPC);
				#end
			}

			doSwagNoteTests();
			doXPosNoteMove();

			// if (FlxG.keys.pressed.SPACE)
			//	defaultCamZoom = zoomin;
			// else
			//	defaultCamZoom = bruhZoom;

			for (strum in playerStrums.members)
			{
				var add:Float = (strum.noteScroll < -1 ? 0 : -elapsed);
				if (FlxG.keys.pressed.FOUR)
					strum.noteScroll += add;
				var adad:Float = (strum.noteScroll >= 1 ? 0 : elapsed);
				if (FlxG.keys.pressed.FIVE)
					strum.noteScroll += adad;

				if (FlxG.keys.pressed.NUMPADEIGHT)
					strum.y -= 1;
				if (FlxG.keys.pressed.NUMPADFOUR)
					strum.x -= 1;
				if (FlxG.keys.pressed.NUMPADTWO)
					strum.y += 1;
				if (FlxG.keys.pressed.NUMPADSIX)
					strum.x += 1;
			}

			for (strum in p2Strums.members)
			{
				var add:Float = (strum.noteScroll < -1 ? 0 : -elapsed);
				if (FlxG.keys.pressed.FOUR)
					strum.noteScroll += add;
				var adad:Float = (strum.noteScroll >= 1 ? 0 : elapsed);
				if (FlxG.keys.pressed.FIVE)
					strum.noteScroll += adad;

				if (FlxG.keys.pressed.NUMPADEIGHT)
					strum.y -= 1;
				if (FlxG.keys.pressed.NUMPADFOUR)
					strum.x -= 1;
				if (FlxG.keys.pressed.NUMPADTWO)
					strum.y += 1;
				if (FlxG.keys.pressed.NUMPADSIX)
					strum.x += 1;
			}
		}

		if (FlxG.keys.justPressed.SIX)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;
			#if sys
			if (!FileSystem.exists(Paths.modChar(SONG.player1)) && !FileSystem.exists(Paths.char(SONG.player1)))
			{
				var mes = "Uh oh, we can't find a following character json: "
					+ SONG.player1
					+ ".json\nMake sure that the character json is exists or create\na new character on this engine's modding state!";
				openSubState(new MissingFileMessage(mes, 'Error', function()
				{
					FlxG.switchState(new CharacterEditor(true, true, true));
				}));
				// return;
			}
			else
			{
			#end
				FlxG.switchState(new CharacterEditor(true, false, true));
			#if sys
			}
			#end
		}

		if (FlxG.keys.justPressed.EIGHT)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;
			#if sys
			if (!FileSystem.exists(Paths.modChar(SONG.player2)) && !FileSystem.exists(Paths.char(SONG.player2)))
			{
				var mes = "Uh oh, we can't find a following character json: "
					+ SONG.player2
					+ ".json\nMake sure that the character json is exists or create\na new character on this engine's modding state!";
				openSubState(new MissingFileMessage(mes, 'Error', function()
				{
					FlxG.switchState(new CharacterEditor(true, true, false));
				}));
				// return;
			}
			else
			{
			#end
				FlxG.switchState(new CharacterEditor(true, false, false));
			#if sys
			}
			#end
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += (FlxG.elapsed * 1000);
				Conductor.rawTime = Conductor.songPosition;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += (FlxG.elapsed * 1000);
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.rawTime = FlxG.sound.music.time;
			if (!paused)
			{
				// Conductor.songPosition = FlxG.sound.music.time;
				if (FlxG.save.data.songtime)
				{
					songPosBG.visible = false;
					songPosBGspr.visible = true;
					songName.visible = true;
					songPosBar.visible = true;
				}
				else
				{
					songPosBG.visible = false;
					songPosBGspr.visible = false;
					songName.visible = false;
					songPosBar.visible = false;
				}

				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if (FlxG.save.data.songtime)
				{
					songPercent = SongPosition.getSongPercent(FlxG.sound.music.time, FlxG.sound.music.length);
					songName.text = SONG.song // .replace('-', ' ')
						+ ' '
						+ difficultyName
						+ " ("
						+ SongPosition.getSongDuration(FlxG.sound.music.time, FlxG.sound.music.length)
						+ ")";
					songName.screenCenter(X);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}
		// moveCamera(Math.floor(curStep / 16));
		if (!forceCameraPos)
		{
			mustHitCamera();
		}
		else
		{
			camFollow.setPosition(camPosForced[0], camPosForced[1]);
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CDevConfig.utils.bound(1 - (elapsed * 4), 0, 1));
			camHUD.zoom = FlxMath.lerp(defaultHudZoom, camHUD.zoom, CDevConfig.utils.bound(1 - (elapsed * 4), 0, 1));
		}

		timeShit += elapsed;
		if (timeShit > 1)
			judgementText.alpha = FlxMath.lerp(0, judgementText.alpha, CDevConfig.utils.bound(1 - (elapsed * 4), 0, 1));

		var theJudgeScale:Float = FlxMath.lerp(1, judgementText.scale.x, CDevConfig.utils.bound(1 - (elapsed * 12), 0, 1));
		judgementText.scale.set(theJudgeScale, theJudgeScale);
		if (sRating != null)
		{
			timeS += elapsed;
			sRating.y = FlxMath.lerp(FlxG.save.data.rY, sRating.y, CDevConfig.utils.bound(1 - (elapsed * 12), 0, 1));

			if (timeS > Conductor.crochet * 0.001)
				sRating.alpha = FlxMath.lerp(0, sRating.alpha, CDevConfig.utils.bound(1 - (elapsed * 6), 0, 1));

			numGroup.forEachAlive(function(spr:FlxSprite)
			{
				if (FlxG.save.data.cChanged)
				{
					spr.x = FlxG.save.data.cX + (43 * spr.ID);
				}
				else
				{
					spr.x = sRating.x + (43 * spr.ID) - 50;
				}
				// spr.x = (sRating.x + (sRating.width / 2)) - ((43 * (spr.ID - 1))) + 50;
				// spr.x = sRating.x + (43 * spr.ID) - 50;
				if (FlxG.save.data.cChanged)
				{
					spr.y = FlxMath.lerp(FlxG.save.data.cY, spr.y, CDevConfig.utils.bound(1 - (elapsed * 12), 0, 1));
				}
				else
				{
					spr.y = FlxMath.lerp(sRating.y + 100, spr.y, CDevConfig.utils.bound(1 - (elapsed * 12), 0, 1));
				}

				if (timeS > Conductor.crochet * 0.001)
					spr.alpha = FlxMath.lerp(0, spr.alpha, CDevConfig.utils.bound(1 - (elapsed * 6), 0, 1));
			});
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		beatBasedEvents();

		if (!inCutscene)
			songEventHandler();

		// better streaming of shit

		// RESET = Quick Game Over Screen

		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (!playingLeftSide)
		{
			if (health <= 0)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				// vocals_opponent.stop();
				FlxG.sound.music.stop();

				openSubState(new substates.GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				if (Main.discordRPC)
					DiscordClient.changePresence("Game Over - " + detailsText, daRPCInfo, iconRPC);
				#end
			}
		}
		else
		{
			if (health >= 2)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				// vocals_opponent.stop();
				FlxG.sound.music.stop();

				openSubState(new substates.GameOverSubstate(dad.getScreenPosition().x, dad.getScreenPosition().y));

				// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				if (Main.discordRPC)
					DiscordClient.changePresence("Game Over - " + detailsText, daRPCInfo, iconRPC);
				#end
			}
		}

		notesUpdateFunction();
		cameraFunctions();
		voice_panning();

		if (!inCutscene)
			keyShit();

		if (FlxG.save.data.botplay)
		{
			bpsl = FlxMath.lerp(1, botplayTxt.scale.x, CDevConfig.utils.bound(1 - (elapsed * 9), 0, 1));
			botplayTxt.scale.set(bpsl, bpsl);
		}
	}

	var bpsl:Float; // botplay scale lerp;
	var healthBarPercent:Float = 0;

	function iconUpdateFunction(elapsed:Float)
	{
		p1Lerp = FlxMath.lerp(1, iconP1.scale.x, CDevConfig.utils.bound(1 - (elapsed * 8), 0, 1));
		p2Lerp = FlxMath.lerp(1, iconP2.scale.x, CDevConfig.utils.bound(1 - (elapsed * 8), 0, 1));

		iconP1.scale.set(p1Lerp, p1Lerp);
		iconP2.scale.set(p2Lerp, p2Lerp);

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 5;

		healthBarPercent = FlxMath.lerp(healthBar.percent, healthBarPercent, CDevConfig.utils.bound(1 - (elapsed * 15), 0, 1));
		// iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBarPercent, 0, 100, 100, 0) * 0.01) - 150 + (150 * iconP1.scale.x) - iconOffset);
		// iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBarPercent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) + iconOffset;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBarPercent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBarPercent, 0, 100, 100, 0) * 0.01)) - 150 + iconOffset;

		iconP1.y = healthBar.y - 70;
		iconP2.y = healthBar.y - 70;
		// smooth healthbar shit
		healthLerp = FlxMath.lerp(health, healthLerp, CDevConfig.utils.bound(1 - (elapsed * 15), 0, 1));

		if (!playingLeftSide)
		{
			if (health > 2)
				health = 2;
		}
		else
		{
			if (health < 0)
				health = 0;
		}

		if (healthBarPercent < 20)
		{
			if (iconP2.hasWinningIcon)
				iconP2.animation.curAnim.curFrame = 2;

			iconP1.animation.curAnim.curFrame = 1;
		}

		if (healthBarPercent > 80)
		{
			if (iconP1.hasWinningIcon)
				iconP1.animation.curAnim.curFrame = 2;

			iconP2.animation.curAnim.curFrame = 1;
		}

		if (healthBarPercent > 20 && healthBarPercent < 80)
		{
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
		}
	}

	function notesUpdateFunction()
	{
		if (unspawnNotes[0] != null)
		{
			var daTime:Float = 1500;

			var speed:Float = 0; // FlxMath.roundDecimal((scrSpd >= 1 || scrSpd < 1 ? scrSpd : SONG.speed));

			if (scrSpd >= 1 || scrSpd < 1)
				speed = FlxMath.roundDecimal(scrSpd, 2);
			else
				speed = FlxMath.roundDecimal(SONG.speed, 2);

			if (speed < 1)
				daTime /= speed;

			while (unspawnNotes.length > 0
				&& unspawnNotes[0].strumTime - Conductor.songPosition < daTime * (songSpeed == 1 ? 1 : songSpeed))
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (FlxG.save.data.downscroll)
				{
					if (((Conductor.songPosition - Conductor.safeZoneOffset) > daNote.strumTime + (Conductor.crochet / 4)))
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
				}
				else
				{
					if (daNote.strumTime < (Conductor.songPosition - Conductor.safeZoneOffset))
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
				}

				if (!FlxG.save.data.middlescroll)
				{
					if (daNote.followX)
						daNote.x = (daNote.mustPress ? playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x : p2Strums.members[Math.floor(Math.abs(daNote.noteData))].x);
				}
				else
				{
					daNote.x = (FlxG.save.data.middlescroll ? playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x : p2Strums.members[Math.floor(Math.abs(daNote.noteData))].x);
				}

				if (daNote.followX)
				{
					if (!daNote.isPixelSkinNote)
					{
						if (daNote.isSustainNote)
							daNote.x += daNote.width / 2 + 20;
					}
					else
					{
						if (daNote.isSustainNote)
							daNote.x += daNote.width / 2 + 15;
					}
				}

				if (!daNote.mustPress && FlxG.save.data.middlescroll)
				{
					if (FlxG.save.data.bgNote)
						daNote.alpha = 0.1;
					else
						daNote.alpha = 0;
				}
				var strum:StrumArrow = daNote.mustPress ? playerStrums.members[daNote.noteData] : p2Strums.members[daNote.noteData];
				if (!FlxG.save.data.middlescroll)
				{
					if (daNote.followAlpha)
					{
						if (daNote.isSustainNote)
						{
							daNote.alpha = strum.alpha * 0.6;
						}
						else
						{
							daNote.alpha = strum.alpha;
						}
					}
				}

				if (daNote.followAngle)
				{
					if (!daNote.isSustainNote)
					{
						daNote.angle = strum.angle;
					}
				}

				// daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

				// ass
				var currentSongTime:Float = 0;
				var shouldDiv:Bool = false;

				if (songSpeed == 1)
				{
					currentSongTime = Conductor.songPosition;
					shouldDiv = false;
				}
				else
				{
					currentSongTime = Conductor.rawTime;
					shouldDiv = true;
				}

				// oh god
				if (strum.noteScroll < 0)
				{
					if (((Conductor.songPosition - RatingsCheck.theTimingWindow[0]) > daNote.strumTime + (Conductor.crochet / 4))
						&& !FlxG.save.data.botplay)
						daNote.tooLate = true;
					else if (((Conductor.songPosition - RatingsCheck.theTimingWindow[0]) > daNote.strumTime + (Conductor.crochet / 4))
						&& FlxG.save.data.botplay)
						goodNoteHit(daNote);

					if (!daNote.mustPress)
					{
						if (daNote.followY)
						{
							daNote.y = ((p2Strums.members[Math.floor(Math.abs(daNote.noteData))].y
								+
								0.45 * (shouldDiv ? ((currentSongTime - daNote.strumTime) / songSpeed) : ((currentSongTime - daNote.strumTime))) * (FlxMath.roundDecimal(scrSpd == 1 ? SONG.speed * (strum.noteScroll
									- strum.noteScroll * (2)) : scrSpd * (strum.noteScroll - strum.noteScroll * (2)),
									2)))
								- daNote.noteYOffset);
						}
					}
					else
					{
						if (daNote.followY)
						{
							daNote.y = ((playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
								+
								0.45 * (shouldDiv ? ((currentSongTime - daNote.strumTime) / songSpeed) : ((currentSongTime - daNote.strumTime))) * (FlxMath.roundDecimal(scrSpd == 1 ? SONG.speed * (strum.noteScroll
									- strum.noteScroll * (2)) : scrSpd * (strum.noteScroll - strum.noteScroll * (2)),
									2))
								- daNote.noteYOffset));
						}
					}

					if (daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith("end") && daNote.prevNote != null)
						{
							// daNote.y -= ((daNote.prevNote.height / 2));
							if (daNote.prevNote.isSustainNote)
								daNote.y += (daNote.prevNote.graphicHeightOrigin * daNote.prevNote.theYScale);
						}
						else
						{
							daNote.y += (daNote.graphicHeightOrigin / 2);
						}

						if (!FlxG.save.data.botplay)
						{
							if (daNote.mustPress)
							{
								if (!daNote.tooLate)
								{
									if (daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2)
										&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
									{
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
											+ Note.swagWidth / 2
											- daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;

										daNote.clipRect = swagRect;
									}
								}
							}
							else
							{
								if (!daNote.tooLate)
								{
									if (daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2)
										&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
									{
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (p2Strums.members[Math.floor(Math.abs(daNote.noteData))].y
											+ Note.swagWidth / 2
											- daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;

										daNote.clipRect = swagRect;
									}
								}
							}
						}
						else
						{
							if (daNote.mustPress)
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
								swagRect.height = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
									+ Note.swagWidth / 2
									- daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
							else
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
								swagRect.height = (p2Strums.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
					}
				}
				else
				{
					if (!daNote.mustPress)
					{
						if (daNote.followY)
						{
							daNote.y = ((p2Strums.members[Math.floor(Math.abs(daNote.noteData))].y
								- 0.45 * (shouldDiv ? ((currentSongTime - daNote.strumTime) / songSpeed) : ((currentSongTime - daNote.strumTime))) * (FlxMath.roundDecimal(scrSpd == 1 ? SONG.speed * strum.noteScroll : scrSpd * strum.noteScroll,
									2)))
								+ daNote.noteYOffset);
						}
					}
					else
					{
						if (daNote.followY)
						{
							daNote.y = ((playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
								- 0.45 * (shouldDiv ? ((currentSongTime - daNote.strumTime) / songSpeed) : ((currentSongTime - daNote.strumTime))) * (FlxMath.roundDecimal(scrSpd == 1 ? SONG.speed * strum.noteScroll : scrSpd * strum.noteScroll,
									2)))
								+ daNote.noteYOffset);
						}
					}

					if (daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith("end") && daNote.prevNote != null)
						{
							// fixed the annoying gap between the trail note and trail end note.
							if (daNote.prevNote.isSustainNote)
							{
								daNote.y = daNote.prevNote.y + (daNote.prevNote.graphicHeightOrigin * daNote.prevNote.theYScale);
								daNote.y -= 60 * (1 - (Conductor.fakeCrochet / 600)) * (FlxMath.roundDecimal(scrSpd == 1 ? SONG.speed : scrSpd, 2));
							}
						}

						if (!FlxG.save.data.botplay)
						{
							if (daNote.mustPress || !daNote.tooLate)
							{
								if (daNote.isSustainNote
									&& daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2)
									&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
								{
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ Note.swagWidth / 2
										- daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
							}
						}
						else
						{
							var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
							swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;

							daNote.clipRect = swagRect;
						}
					}
				}

				// daNote.y = (strumLineNotes.members[daNote.noteData].y + (Conductor.songPosition - daNote.strumTime) * (FlxMath.roundDecimal(SONG.speed, 2)));
				// if (daNote.isSustainNote
				//	&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
				//	&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				//	{
				//		var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
				//		swagRect.y /= daNote.scale.y;
				//		swagRect.height -= swagRect.y;

				//		daNote.clipRect = swagRect;
				//	}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";
					var altAnimIsYes:Bool = false;

					if (!playingLeftSide)
					{
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							{
								altAnimIsYes = true;
								altAnim = '-alt';
							}
						}
					}
					else
					{
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].p1AltAnim)
							{
								altAnimIsYes = true;
								altAnim = '-alt';
							}
						}
					}

					p2Strums.members[daNote.noteData].playAnim('confirm', true);
					/*if (!isPixel)
						{
							p2Strums.members[daNote.noteData].centerOffsets();
							if (FlxG.save.data.fnfNotes)
							{
								p2Strums.members[daNote.noteData].offset.x -= 13;
								p2Strums.members[daNote.noteData].offset.y -= 13;
							}
							else
							{
								p2Strums.members[daNote.noteData].offset.x -= 30;
								p2Strums.members[daNote.noteData].offset.y -= 30;
							}
						}
						else
						{
							p2Strums.members[daNote.noteData].centerOffsets();
					}*/

					var anim:String = '';
					var animToPlay:String = '';
					switch (Math.abs(daNote.noteData))
					{
						case 0:
							anim = 'singLEFT';
							cameraMovements(anim, false);
						case 1:
							anim = 'singDOWN';
							cameraMovements(anim, false);
						case 2:
							anim = 'singUP';
							cameraMovements(anim, false);
						case 3:
							anim = 'singRIGHT';
							cameraMovements(anim, false);
					}
					if (playingLeftSide)
					{
						if (altAnimIsYes)
						{
							if (boyfriend.animOffsets.exists(anim + altAnim))
							{
								animToPlay = anim + altAnim;
							}
						}
						else
						{
							animToPlay = anim;
						}
						boyfriend.playAnim(animToPlay, true);
						boyfriend.holdTimer = 0;
					}
					else
					{
						if (altAnimIsYes)
						{
							if (dad.animOffsets.exists(anim + altAnim))
							{
								animToPlay = anim + altAnim;
							}
						}
						else
						{
							animToPlay = anim;
						}
						dad.playAnim(animToPlay, true);

						dad.holdTimer = 0;
					}

					if (SONG.needsVoices)
						vocals.volume = 1;
					// if (SONG.needsVoices)
					//	vocals_opponent.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();

					// we do some changes here.
					if (playingLeftSide)
						scripts.executeFunc('p1NoteHit', [daNote.noteData, daNote.isSustainNote]);
					else
						scripts.executeFunc('p2NoteHit', [daNote.noteData, daNote.isSustainNote]);
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll)
					&& daNote.mustPress)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else
					{
						// health -= 0.075;
						vocals.volume = 0;

						noteMiss(daNote.noteData);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		p2Strums.forEach(function(spr:StrumArrow)
		{
			if (spr.animation.finished)
			{
				spr.playAnim('static', false);
			}
		});
	}

	function cameraFunctions()
	{
		if (generatedMusic && PlayState.SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (!PlayState.SONG.notes[Math.floor(curStep / 16)].mustHitSection)
			{
				if (dad.animation.curAnim.name == 'idle'
					|| dad.animation.curAnim.name == 'danceLeft'
					|| dad.animation.curAnim.name == 'danceRight')
				{
					dadCamX = 0;
					dadCamY = 0;
				}
			}
			if (PlayState.SONG.notes[Math.floor(curStep / 16)].mustHitSection)
			{
				if (boyfriend.animation.curAnim.name == 'idle'
					|| boyfriend.animation.curAnim.name == 'danceLeft'
					|| boyfriend.animation.curAnim.name == 'danceRight')
				{
					bfCamX = 0;
					bfCamY = 0;
				}
			}
			if (!PlayState.SONG.notes[Math.floor(curStep / 16)].mustHitSection)
			{
				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Math.floor(curStep / 16)].mustHitSection)
			{
				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}
	}

	var gunsBanger:Bool = false;

	function beatBasedEvents()
	{
		// this if () code is used for hey anims on certain part of the song
		if (generatedMusic)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'guns':
					{
						if (gunsBanger)
						{
							// FlxG.camera.angle = Math.sin((game.Conductor.songPosition / 1000) * (game.Conductor.bpm / 60) * -1.0) * 2;
							camHUD.angle = Math.sin((game.Conductor.songPosition / 1000) * (game.Conductor.bpm / 60) * -1.0) * 0.5;

							cameraPosition.y = Math.sin((game.Conductor.songPosition / 1000) * (game.Conductor.bpm / 60) * -1.0) * 24;
						}
					}
				case 'philly':
					{
						if (curBeat < 250)
						{
							if (curBeat != 184 && curBeat != 216)
							{
								if (curBeat % 16 == 8)
								{
									if (!cheeringBF)
									{
										gf.playAnim('cheer', true);
										cheeringBF = true;
									}
								}
								else
									cheeringBF = false;
							}
						}
					}
				case 'bopeebo':
					{
						if (curBeat > 5 && curBeat < 130)
						{
							if (curBeat % 8 == 7)
							{
								if (!cheeringBF)
								{
									gf.playAnim('cheer', true);
									cheeringBF = true;
								}
							}
							else
								cheeringBF = false;
						}
					}
				case 'blammed':
					{
						if (curBeat > 30 && curBeat < 190)
						{
							if (curBeat < 90 || curBeat > 128)
							{
								if (curBeat % 4 == 2)
								{
									if (!cheeringBF)
									{
										gf.playAnim('cheer', true);
										cheeringBF = true;
									}
								}
								else
									cheeringBF = false;
							}
						}
					}
				case 'cocoa':
					{
						if (curBeat < 170)
						{
							if (curBeat < 65 || curBeat > 130 && curBeat < 145)
							{
								if (curBeat % 16 == 15)
								{
									if (!cheeringBF)
									{
										gf.playAnim('cheer', true);
										cheeringBF = true;
									}
								}
								else
									cheeringBF = false;
							}
						}
					}
				case 'eggnog':
					{
						if (curBeat > 10 && curBeat != 111 && curBeat < 220)
						{
							if (curBeat % 8 == 7)
							{
								if (!cheeringBF)
								{
									gf.playAnim('cheer', true);
									cheeringBF = true;
								}
							}
							else
								cheeringBF = false;
						}
					}
			}
		}

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
			}
		}
	}

	function mustHitCamera(isBF:Bool = false)
	{
		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (PlayState.SONG.notes[Math.floor(curStep / 16)].mustHitSection)
			{
				switch (curStage)
				{
					case 'limo':
						bfCamXPos = boyfriend.getMidpoint().x - 300;
						bfCamYPos = boyfriend.getMidpoint().y - 100;
					case 'mall':
						bfCamYPos = boyfriend.getMidpoint().y - 200;
						bfCamXPos = boyfriend.getMidpoint().x - 100;
					case 'school':
						bfCamXPos = boyfriend.getMidpoint().x - 200;
						bfCamYPos = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						bfCamXPos = boyfriend.getMidpoint().x - 200;
						bfCamYPos = boyfriend.getMidpoint().y - 200;
					default:
						bfCamXPos = boyfriend.getMidpoint().x - 100;
						bfCamYPos = boyfriend.getMidpoint().y - 100;
				}

				camFollow.setPosition(bfCamXPos + cameraPosition.x + bfCamX, bfCamYPos + cameraPosition.y + bfCamY);

				camFollow.x -= boyfriend.charCamPos[0];
				camFollow.y += boyfriend.charCamPos[1];
			}
			if (!PlayState.SONG.notes[Math.floor(curStep / 16)].mustHitSection)
			{
				switch (dad.curCharacter)
				{
					case 'mom':
						dadCamXPos = dad.getMidpoint().x + 150;
						dadCamYPos = dad.getMidpoint().y;
					case 'senpai':
						dadCamYPos = dad.getMidpoint().y - 430;
						dadCamXPos = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						dadCamYPos = dad.getMidpoint().y - 430;
						dadCamXPos = dad.getMidpoint().x - 100;
					default:
						dadCamXPos = dad.getMidpoint().x + 150;
						dadCamYPos = dad.getMidpoint().y - 100;
				}

				camFollow.setPosition(dadCamXPos + cameraPosition.x + dadCamX, dadCamYPos + cameraPosition.y + dadCamY);

				camFollow.x += dad.charCamPos[0];
				camFollow.y += dad.charCamPos[1];
			}
		}
	}

	function voice_panning()
	{
		// if (vocals.playing) vocals.proximity(bfCamXPos + boyfriend.charCamPos[0], bfCamYPos + boyfriend.charCamPos[1], camFollow,1200,true);
		// if (vocals_opponent.playing) vocals_opponent.proximity(dadCamXPos + dad.charCamPos[0], dadCamYPos + dad.charCamPos[1], camFollow,1200,true);
	}

	public function killnoteshit()
	{
		for (i in 0...unspawnNotes.length)
		{
			var daNote:Note = unspawnNotes[0];

			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
			daNote.destroy();
		}
	}

	public function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;

		vocals.volume = 0;
		vocals.kill();

		// vocals_opponent.volume = 0;
		// vocals_opponent.kill();
		FlxG.sound.music.onComplete = null;
		if (SONG.validScore && !chartingMode)
		{
			#if !switch
			var val:Float = convertedAccuracy;
			if (Math.isNaN(val))
				val = 0;
			engineutils.Highscore.saveScore(SONG.song, songScore, storyDifficulty, val, Date.now());
			#end
		}

		if (!chartingMode)
		{
			if (isStoryMode)
			{
				campaignScore += songScore;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					FlxG.switchState(new StoryMenuState());

					// if ()
					// StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						engineutils.Highscore.saveWeekScore(weekName, campaignScore, storyDifficulty);
					}

					// FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "-" + difficultyName;

					// if (storyDifficulty == 0)
					//	difficulty = '-easy';

					// if (storyDifficulty == 2)
					//	difficulty = '-hard';

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					// put your end song cutscenes here
					switch (SONG.song.toLowerCase())
					{
						case 'eggnog':
							var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
								-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
							blackShit.scrollFactor.set();
							add(blackShit);
							camHUD.visible = false;

							FlxG.sound.play(Paths.sound('Lights_Shut_off'));
							FlxG.sound.music.stop();
							new FlxTimer().start(2, function(daTimer:FlxTimer)
							{
								FlxTransitionableState.skipNextTransIn = true;
								FlxTransitionableState.skipNextTransOut = true;
								prevCamFollow = camFollow;

								PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);

								LoadingState.loadAndSwitchState(new PlayState());
							});
						default:
							if (outro_cutscene_script != null)
							{
								inCutscene = true;
								currentCutscene = "outro";
								outro_cutscene_script.executeFunc("outroStart", []);

								outro_cutscene_script.setVariable("endSong", function()
								{
									inCutscene = false;
									outro_cutscene_script.executeFunc("outroEnd", []);
									endSong2();
								});

								outro_cutscene_script.executeFunc("postOutro", []);
							}
							else
							{
								endSong2();
							}
					}

					GameOverSubstate.resetDeathStatus();
				}
			}
			else
			{
				GameOverSubstate.resetDeathStatus();
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
				if (FlxG.save.data.showTraceLogAt == 1)
					TraceLog.clearLogData();
			}
		}
		else
		{
			trace('nah you cant end this song on charting mode >:]');
			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			FlxG.switchState(new states.charter.ChartingState());
			GameOverSubstate.resetDeathStatus();
			if (FlxG.save.data.showTraceLogAt == 1)
				TraceLog.clearLogData();
		}
	}

	function endSong2()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + "-" + difficultyName, PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();

		LoadingState.loadAndSwitchState(new PlayState());
	}

	function zoomIcon()
	{
		// iconP1.setGraphicSize(Std.int(iconP1.width + 50));
		// iconP2.setGraphicSize(Std.int(iconP2.width + 50));

		iconP1.scale.x += 0.3;
		iconP1.scale.y += 0.3;
		iconP1.updateHitbox();

		iconP2.scale.x += 0.3;
		iconP2.scale.y += 0.3;
		iconP2.updateHitbox();
	}

	var endingSong:Bool = false;

	var accuracyScore:Int = 0;

	public static function cleanCache()
	{
		openfl.Assets.cache.clear();
		FlxG.save.flush();
		Paths.destroyLoadedImages();
	}

	var toIgnoreEvents:Array<ChartEvent> = [];

	function songEventHandler()
	{
		for (i in 0...toDoEvents.length)
		{
			var daEvent:ChartEvent = toDoEvents[i];

			if (!toIgnoreEvents.contains(daEvent))
			{
				var nameShit:String = Std.string(daEvent.EVENT_NAME);
				var strum:Float = daEvent.time;
				var input1:String = Std.string(daEvent.value1);
				var input2:String = Std.string(daEvent.value2);

				if (strum < FlxG.sound.music.time)
				{
					executeEvents(daEvent, nameShit, input1, input2);
					toIgnoreEvents.push(daEvent);
				}
			}
		}
	}

	// also add your custom events here.
	public static function executeEvents(event:ChartEvent, nameShit:String, input1:String, input2:String)
	{
		TraceLog.addLogData("Executed Event: " + nameShit);
		if (eventNames.contains(nameShit))
		{
			switch (nameShit)
			{
				case 'Add Camera Zoom':
					if (FlxG.save.data.camZoom)
					{
						var fkinCam:String = input1.toLowerCase().trim();
						var fkinZoom:Float = (!Math.isNaN(Std.parseFloat(input2)) ? Std.parseFloat(input2) : 0.3);
						if (fkinCam == 'gamecam')
						{
							FlxG.camera.zoom += fkinZoom;
						}
						else if (fkinCam == 'hudcam')
						{
							camHUD.zoom += fkinZoom;
						}
						else
						{
							FlxG.camera.zoom += fkinZoom;
						}
					}

				case 'Force Camera Position':
					var posShit:Array<Float> = [Std.parseFloat(input1), Std.parseFloat(input2)];
					if (Math.isNaN(posShit[0]) || Math.isNaN(posShit[1]))
					{
						forceCameraPos = true;
						if (posShit[0] == 0 && posShit[1] == 0)
						{
							forceCameraPos = false;
						}
						else
						{
							camPosForced = posShit;
						}
					}
				case 'Play Animation':
					var daChar:String = input1;
					if (daChar == 'dad')
					{
						dad.playAnim(input2, true);
						dad.specialAnim = true;
					}
					else if (daChar == 'gf')
					{
						gf.playAnim(input2, true);
						gf.specialAnim = true;
					}
					else if (daChar == 'bf')
					{
						boyfriend.playAnim(input2, true);
						boyfriend.specialAnim = true;
					}
				case 'Change Scroll Speed':
					scrSpd = Std.parseFloat(input1);
			}
		}
		else
		{
			scripts.executeFunc('onEvent', [nameShit, input1, input2]);
		}
	}

	private function popUpScore(daNote:Note, isSus:Bool):Void
	{
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();

		var score:Int = 350;

		var daRating = daNote.rating;

		if (!isSus)
		{
			switch (daRating)
			{
				case 'shit':
					shit++;
					daRating = 'shit';
					score = 50;
					if (!isSus)
						accuracyScore += 100;
				case 'bad':
					bad++;
					daRating = 'bad';
					score = 100;
					if (!isSus)
						accuracyScore += 200;
				case 'good':
					good++;
					daRating = 'good';
					score = 200;
					if (!isSus)
						accuracyScore += 300;
				case 'sick':
					sick++;
					daRating = 'sick';
					score = 350;
					if (!isSus)
						accuracyScore += 400;
					if (!isSus)
					{
						if (FlxG.save.data.noteImpact)
							notePressAt(daNote);
					}
				case 'perfect':
					perfect++;
					daRating = 'perfect';
					score = 450;
					if (!isSus)
					{
						accuracyScore += 400;
						if (FlxG.save.data.noteImpact)
							notePressAt(daNote);
					}
			}
		}
		else
		{
			daRating = 'perfect';
			accuracyScore += 400;
			score = 450;
		}
		// if (FlxG.save.data.botplay)
		// score = 0;

		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */
		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';
		var librshit:String = 'shared';

		if (isPixel)
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
			librshit = 'week6';
		}
		if (FlxG.save.data.multiRateSprite)
		{
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2, librshit));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;

			if (FlxG.save.data.rChanged)
			{
				rating.x = FlxG.save.data.rX;
				rating.y = FlxG.save.data.rY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			rating.cameras = [config.ratingSpriteCamera];

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2, librshit));
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);

			if (!isPixel)
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = FlxG.save.data.antialiasing;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = FlxG.save.data.antialiasing;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			comboSpr.updateHitbox();
			rating.updateHitbox();

			var seperatedScore:Array<Int> = [];

			// bruh.
			if (combo >= 100000)
				seperatedScore.push(Math.floor(combo / 100000) % 10);

			// for overcharted songs or shit idk
			if (combo >= 10000)
				seperatedScore.push(Math.floor(combo / 10000) % 10);

			if (combo >= 1000)
				seperatedScore.push(Math.floor(combo / 1000) % 10);

			seperatedScore.push(Math.floor(combo / 100) % 10);
			seperatedScore.push(Math.floor(combo / 10) % 10);
			seperatedScore.push(combo % 10);
			var daLoop:Int = 0;

			var sus:String = (isPixel ? 'week6' : 'shared');
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2, sus));
				numScore.screenCenter();
				if (FlxG.save.data.cChanged)
				{
					numScore.x = FlxG.save.data.cX + (43 * daLoop) - 50;
					numScore.y = FlxG.save.data.cY;
				}
				else
				{
					numScore.x = rating.x + (43 * daLoop) - 50;
					numScore.y = rating.y + 100;
				}

				if (!isPixel)
				{
					numScore.antialiasing = FlxG.save.data.antialiasing;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
				numScore.cameras = [config.ratingSpriteCamera];

				// if (combo >= 10 || combo == 0)
				add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001
			});
			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();

					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
		else
		{
			timeS = 0;

			if (sRating != null)
			{
				remove(sRating);
			}

			sRating = new FlxSprite();
			sRating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2, librshit));
			sRating.screenCenter();
			sRating.y -= 50;
			sRating.x = coolText.x - 125;

			if (FlxG.save.data.rChanged)
			{
				sRating.x = FlxG.save.data.rX;
				sRating.y = FlxG.save.data.rY - 20;
			}
			sRating.cameras = [config.ratingSpriteCamera];
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2, librshit));
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);

			if (!isPixel)
			{
				sRating.setGraphicSize(Std.int(sRating.width * 0.7));
				sRating.antialiasing = FlxG.save.data.antialiasing;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = FlxG.save.data.antialiasing;
			}
			else
			{
				sRating.setGraphicSize(Std.int(sRating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			comboSpr.updateHitbox();
			sRating.updateHitbox();
			add(sRating);

			var seperatedScore:Array<Int> = [];

			// bruh.

			var comboString:String = Std.string(combo);
			var comboArray:Array<String> = comboString.split('');
			for (i in 0...comboArray.length)
			{
				seperatedScore.push(Std.parseInt(comboArray[i]));
			}
			// if (combo >= 100000)
			//	seperatedScore.push(Math.floor(combo / 100000) % 10);

			// for overcharted songs or shit idk
			// if (combo >= 10000)
			//	seperatedScore.push(Math.floor(combo / 10000) % 10);

			// if (combo >= 1000)
			//	seperatedScore.push(Math.floor(combo / 1000) % 10);

			// seperatedScore.push(Math.floor(combo / 100) % 10);
			// seperatedScore.push(Math.floor(combo / 10) % 10);
			///seperatedScore.push(combo % 10);
			var daLoop:Int = 0;

			var sus:String = (isPixel ? 'week6' : 'shared');
			numGroup.clear();
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2, sus));
				numScore.screenCenter();

				if (FlxG.save.data.cChanged)
				{
					numScore.x = FlxG.save.data.cX + (43 * daLoop);
					numScore.y = FlxG.save.data.cY - 20;
				}
				else
				{
					numScore.x = sRating.x + (43 * daLoop) - 50;
					numScore.y = sRating.y + 100 - 20;
				}
				numScore.ID = daLoop;

				if (!isPixel)
				{
					numScore.antialiasing = FlxG.save.data.antialiasing;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
				// if (combo >= 10 || combo == 0)
				numGroup.add(numScore);

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	private function keyShit():Void
	{
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		if (FlxG.save.data.botplay) // blocking the player's inputs
		{
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
		}

		if (holdArray.contains(true))
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
				{
					goodNoteHit(daNote);
				}
			});
		}

		if (pressArray.contains(true) && FlxG.save.data.hitsound)
			FlxG.sound.play(Paths.sound('hitsound', 'shared'), 0.6);

		if (pressArray.contains(true) && generatedMusic)
		{
			boyfriend.holdTimer = 0;
			var possibleNotes:Array<Note> = [];
			var directions:Array<Int> = [];
			var countedDirs:Array<Bool> = [false, false, false, false];

			var killList:Array<Note> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
					goodNoteHit(daNote);
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directions.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
							{
								killList.push(daNote);
								break;
							}
							else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
							{
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directions.push(daNote.noteData);
					}
				}
			});
			for (daNote in killList)
			{
				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			var blockNote:Bool = false;
			for (i in 0...pressArray.length)
			{
				if (pressArray[i] && !directions.contains(i))
					blockNote = true;
			}

			if (possibleNotes.length > 0 && !blockNote)
			{
				if (!FlxG.save.data.ghost)
				{
					for (shit in 0...pressArray.length)
						if (pressArray[shit] && !directions.contains(shit))
							noteMiss(shit);
				}
				for (note in possibleNotes)
				{
					if (pressArray[note.noteData])
					{
						goodNoteHit(note);
					}
				}
			}
			else if (!FlxG.save.data.ghost)
			{
				for (shit in 0...pressArray.length)
					if (pressArray[shit])
						noteMiss(shit);
			}

			if (possibleNotes.length > 0 && !blockNote && FlxG.save.data.ghost && !FlxG.save.data.botplay)
			{
				if (pressedNotes > 4)
					noteMiss(0);
				else
					pressedNotes++;
			}
		}

		notes.forEachAlive(function(daNote:Note)
		{
			if (FlxG.save.data.downscroll
				&& daNote.y > playerStrums.members[daNote.noteData].y
				|| !FlxG.save.data.downscroll
				&& daNote.y < playerStrums.members[daNote.noteData].y)
			{
				if (FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress || FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
				{
					goodNoteHit(daNote);

					// if (!playingLeftSide)
					boyfriend.holdTimer = 0;
				}
			}
		});

		if (!playingLeftSide)
		{
			if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.charHoldTime
				&& boyfriend.animation.curAnim.name.startsWith('sing')
				&& !boyfriend.animation.curAnim.name.endsWith('miss')
				&& (!holdArray.contains(true) || FlxG.save.data.botplay))
			{
				boyfriend.dance();
			}
		}
		else
		{
			if (dad.holdTimer > Conductor.stepCrochet * 0.001 * dad.charHoldTime
				&& dad.animation.curAnim.name.startsWith('sing')
				&& !dad.animation.curAnim.name.endsWith('miss')
				&& (!holdArray.contains(true) || FlxG.save.data.botplay))
			{
				dad.dance();
			}
		}

		if (!FlxG.save.data.botplay)
		{
			playerStrums.forEach(function(spr:StrumArrow)
			{
				if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
					spr.playAnim('pressed', false);
				if (!holdArray[spr.ID])
					spr.playAnim('static', false);
			});
		}
		else
		{
			playerStrums.forEach(function(spr:StrumArrow)
			{
				if (spr.animation.finished)
				{
					spr.playAnim('static', false);
				}
			});
		}
	}

	function checkCanHitNote(daNote:Note):Bool
	{
		var theDiff = Math.abs((daNote.strumTime - game.Conductor.songPosition));
		for (i in 0...RatingsCheck.theTimingWindow.length)
		{
			var judgeTime = RatingsCheck.theTimingWindow[i];
			var newTime = i + 1 > RatingsCheck.theTimingWindow.length - 1 ? 0 : RatingsCheck.theTimingWindow[i + 1];
			if (theDiff < judgeTime && theDiff >= newTime)
			{
				return true;
			}
		}
		return false;
	}

	var when:Float;

	var timesChecked:Float = 0;

	function notePressAt(note:Note)
	{
		if (note != null)
			doArrowEffect(playerStrums.members[note.noteData].x, playerStrums.members[note.noteData].y, note.noteData, note);
	}

	function doArrowEffect(x:Float, y:Float, thedata:Int, ?note:Note = null)
	{
		var click:NotePress = grpNotePresses.recycle(NotePress);
		click.prepareImage(x, y, thedata, note.noteColor);
		grpNotePresses.add(click);
	}

	public var allDaNotesHit:Int = 0;

	public function recalculateAccuracy()
	{
		// i tried to make a new accuracy calculation
		// but turns out that it getting even worser than i thought.

		// convertedAccuracy = Math.max(0, hittedNotes / timesChecked * 100);
		// allDaNotesHit
		convertedAccuracy = (accuracyScore / ((allDaNotesHit + misses) * 400)) * 100;

		// convertedAccuracy = songScore / ((killedNotes + misses) * 350);
		// convertedAccuracy = (hittedNotes / timesChecked) * 100;
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			if (!FlxG.save.data.botplay)
			{
				if (suddenDeath)
					health = -10;
				if (!playingLeftSide)
					health -= 0.075 * healthLoseMulti;
				else
					health += 0.075 * healthLoseMulti;
				if (combo > 5 && gf.animOffsets.exists('sad'))
				{
					gf.playAnim('sad');
				}
				combo = 0;
				misses++;

				songScore -= 10;
				accuracyScore -= 30;

				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
				// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
				// FlxG.log.add('played imss note');

				var animToPlay:String = '';
				switch (Math.floor(direction))
				{
					case 0:
						animToPlay = 'singLEFTmiss';
					case 1:
						animToPlay = 'singDOWNmiss';
					case 2:
						animToPlay = 'singUPmiss';
					case 3:
						animToPlay = 'singRIGHTmiss';
				}

				if (!playingLeftSide)
				{
					if (boyfriend.animOffsets.exists(animToPlay))
						boyfriend.playAnim(animToPlay, true);
				}
				else
				{
					if (dad.animOffsets.exists(animToPlay))
						dad.playAnim(animToPlay, true);
				}

				recalculateAccuracy();

				scripts.executeFunc('onNoteMiss', [direction]);
			}
			else
			{
				goodNoteHit(Note.getNoteInfo(direction));
			}
		}
	}

	var tX:Float = 400;
	var tSpeed:Float = FlxG.random.float(5, 7);
	var tAngle:Float = FlxG.random.int(-90, 45);

	function moveTank(?elapsed:Float = 0):Void
	{
		if (!inCutscene)
		{
			tAngle += elapsed * tSpeed;
			if (tankGround != null)
			{
				tankGround.angle = tAngle - 90 + 15;
				tankGround.x = tX + 1500 * Math.cos(Math.PI / 180 * (1 * tAngle + 180));
				tankGround.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tAngle + 180));
			}
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;

			if (leftP)
				noteMiss(0);
			if (downP)
				noteMiss(1);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
	}*/
	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note);
		else
		{
		}
	}

	var killedNotes:Int = 0;
	var lastMs:Float = 0;

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			note.rating = RatingsCheck.noteJudge(note);

			if (!note.isSustainNote)
			{
				timeShit = 0;
				var colshit:FlxColor = FlxColor.WHITE;
				switch (note.rating)
				{
					case 'shit', 'bad':
						colshit = FlxColor.RED;
					case 'good':
						colshit = FlxColor.LIME;
					case 'sick', 'perfect':
						colshit = FlxColor.CYAN;
				}

				var msShits:Float = Math.abs((note.strumTime - game.Conductor.songPosition));
				judgementText.text = RatingsCheck.fixFloat(msShits, 2) + 'ms';
				judgementText.color = colshit;

				if (FlxG.save.data.showDelay)
					judgementText.alpha = 1;

				var allNoteWidth:Float = (160 * 0.7) * 16;
				judgementText.x = (strumXpos + 50 + (allNoteWidth / 2) - 30 - (judgementText.width / 2)) - (playingLeftSide ? FlxG.width / 2 : 0);
				var strumYPOS:Float = 70;
				if (FlxG.save.data.downscroll)
				{
					if (!FlxG.save.data.middlescroll)
						strumYPOS = FlxG.height - 160;
					else
						strumYPOS = FlxG.height - 175;
					judgementText.y = strumYPOS + (160 * 0.7);
				}
				else
				{
					judgementText.y = strumYPOS / 2;
				}

				judgementText.scale.x = 1.2;
			}

			if (!note.isSustainNote)
			{
				popUpScore(note, false);
				combo += 1 * Std.int(comboMultiplier);
			}
			else
			{
				// songScore += 20;
				popUpScore(note, true);
				combo += 1 * Std.int(comboMultiplier);
			}
			killedNotes++;

			if (!playingLeftSide)
			{
				if (!note.isSustainNote)
					health += 0.06 * healthGainMulti;
				else
					health += 0.03 * healthGainMulti;
			}
			else
			{
				if (!note.isSustainNote)
					health -= 0.06 * healthGainMulti;
				else
					health -= 0.03 * healthGainMulti;
			}

			if (pressedNotes >= 1)
				pressedNotes--;

			if (pressedNotes < 0)
				pressedNotes = 0;

			var altAnim:String = "";
			var altAnimIsYes:Bool = false;

			if (!playingLeftSide)
			{
				if (SONG.notes[Math.floor(curStep / 16)] != null)
				{
					if (SONG.notes[Math.floor(curStep / 16)].p1AltAnim)
					{
						altAnimIsYes = true;
						altAnim = '-alt';
					}
				}
			}
			else
			{
				if (SONG.notes[Math.floor(curStep / 16)] != null)
				{
					if (SONG.notes[Math.floor(curStep / 16)].altAnim)
					{
						altAnimIsYes = true;
						altAnim = '-alt';
					}
				}
			}

			var daAnim:String = '';
			switch (Std.int(Math.abs(note.noteData)))
			{
				case 0:
					daAnim = 'singLEFT';
					cameraMovements(daAnim, true);
				case 1:
					daAnim = 'singDOWN';
					cameraMovements(daAnim, true);
				case 2:
					daAnim = 'singUP';
					cameraMovements(daAnim, true);
				case 3:
					daAnim = 'singRIGHT';
					cameraMovements(daAnim, true);
			}

			var animToPlay:String = '';

			if (!playingLeftSide)
			{
				if (altAnimIsYes)
				{
					if (boyfriend.animOffsets.exists(daAnim + altAnim))
					{
						animToPlay = daAnim + altAnim;
					}
				}
				else
				{
					animToPlay = daAnim;
				}
				boyfriend.playAnim(animToPlay, true);
			}
			else
			{
				if (altAnimIsYes)
				{
					if (dad.animOffsets.exists(daAnim + altAnim))
					{
						animToPlay = daAnim + altAnim;
					}
				}
				else
				{
					animToPlay = daAnim;
				}
				dad.playAnim(animToPlay, true);

				dad.holdTimer = 0;
			}

			playerStrums.forEach(function(spr:StrumArrow)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.playAnim('confirm', true);
				}
			});

			if (FlxG.save.data.hitsound && FlxG.save.data.botplay && !note.isSustainNote)
				FlxG.sound.play(Paths.sound('hitsound', 'shared'), 0.6);

			note.wasGoodHit = true;
			vocals.volume = 1;

			allDaNotesHit += 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			recalculateAccuracy();

			// we do some changes here.
			if (!playingLeftSide)
				scripts.executeFunc('p1NoteHit', [note.noteData, note.isSustainNote]);
			else
				scripts.executeFunc('p2NoteHit', [note.noteData, note.isSustainNote]);
		}
	}

	function cameraMovements(daAnim:String, isBF:Bool = false)
	{
		if (FlxG.save.data.camMovement)
		{
			if (isBF)
			{
				var theAnim:String = daAnim;
				switch (theAnim)
				{
					case 'singLEFT':
						bfCamX = -20;
						bfCamY = 0;
					case 'singDOWN':
						bfCamY = 20;
						bfCamX = 0;
					case 'singUP':
						bfCamY = -20;
						bfCamX = 0;
					case 'singRIGHT':
						bfCamX = 20;
						bfCamY = 0;
				}

				// camFollow.setPosition(bfCamXPos + bfCamX, bfCamYPos + bfCamY);
			}
			if (!isBF)
			{
				var anim:String = daAnim;
				switch (anim)
				{
					case 'singLEFT':
						dadCamX = -20;
						dadCamY = 0;
					case 'singDOWN':
						dadCamY = 20;
						dadCamX = 0;
					case 'singUP':
						dadCamY = -20;
						dadCamX = 0;
					case 'singRIGHT':
						dadCamX = 20;
						dadCamY = 0;
				}
				// camFollow.setPosition(dadCamXPos + dadCamX, dadCamYPos + dadCamY);
			}
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		if (FlxG.save.data.flashing)
		{
			halloweenBG.animation.play('lightning');
			halloweenThunder.alpha = 0.7;

			FlxG.camera.shake(0.01, 0.2);
			FlxG.camera.zoom += 0.050;

			FlxTween.tween(halloweenThunder, {alpha: 0}, 1);
		}

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	public var playingBlammedVideo:Bool = false;

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
		switch (curSong.toLowerCase())
		{
			case 'stress':
				switch (curStep)
				{
					case 252, 253, 254, 255:
						FlxG.camera.zoom += 0.025;
						camHUD.zoom += 0.01;
					case 736:
						dad.canDance = false;
					case 768:
						dad.canDance = true;
				}
		}

		scripts.executeFunc('stepHit', [curStep]);

		if (instantEndSong)
		{
			instantEndSong = false;
			endSong();
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				if (songSpeed != 1)
					Conductor.updateBPMBasedOnSongSpeed(SONG.notes[Math.floor(curStep / 16)].bpm, songSpeed);
				FlxG.log.add('CHANGED BPM!');
			}
		}
		wiggleShit.update(Conductor.crochet);
		if (FlxG.save.data.camZoom)
		{
			if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (camZooming && PlayState.SONG.notes[Std.int(curStep / 16)].banger && !endingSong)
				{
					FlxG.camera.zoom += 0.02;
					camHUD.zoom += 0.03;
				}
			}
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.02;
				camHUD.zoom += 0.03;
			}

			if (camZooming && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.02;
				camHUD.zoom += 0.03;
			}

			if (curSong.toLowerCase() == 'blammed' && curBeat >= 128 && curBeat < 192 && camZooming)
			{
				FlxG.camera.zoom += 0.02;
				camHUD.zoom += 0.03;
			}
		}

		zoomIcon();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!dad.animation.curAnim.name.startsWith('sing'))
		{
			var altIdle:Bool = false;
			if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (SONG.notes[Math.floor(curStep / 16)].altAnim)
				{
					if (dad.animOffsets.exists('idle-alt'))
					{
						altIdle = true;
					}
				}
			}
			if (altIdle)
			{
				dad.playAnim('idle-alt');
			}
			else
			{
				dad.dance();
			}
		}
		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			var altIdle:Bool = false;
			if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (SONG.notes[Math.floor(curStep / 16)].p1AltAnim)
				{
					if (boyfriend.animOffsets.exists('idle-alt'))
					{
						altIdle = true;
					}
				}
			}
			if (altIdle)
			{
				boyfriend.playAnim('idle-alt');
			}
			else
			{
				boyfriend.dance();
			}
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			if (boyfriend.animOffsets.exists('hey'))
				boyfriend.playAnim('hey', true);
			if (gf.animOffsets.exists('cheer'))
				gf.playAnim('cheer', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			if (boyfriend.animOffsets.exists('hey'))
				boyfriend.playAnim('hey', true);
			if (gf.animOffsets.exists('cheer'))
				gf.playAnim('cheer', true);
		}

		switch (curSong.toLowerCase())
		{
			case 'ugh':
				switch (curBeat)
				{
					case 15, 111, 131, 135, 207:
						if (dad.animOffsets.exists('ugh'))
							dad.playAnim('ugh', true);
						dad.specialAnim = true;
				}
			case 'guns':
				if (curBeat >= 128 && curBeat < 160)
				{
					FlxG.camera.zoom += 0.025;
					camHUD.zoom += 0.01;
				}
				switch (curBeat)
				{
					case 224:
						camHUD.flash();
						gunsBanger = true;
					case 288:
						gunsBanger = false;
						// FlxTween.tween(FlxG.camera, {angle: 0}, 1, {ease: FlxEase.circIn});
						FlxTween.tween(camHUD, {angle: 0}, 1, {ease: FlxEase.cubeIn});
						FlxTween.tween(cameraPosition, {y: 0}, 1, {ease: FlxEase.cubeIn});
				}
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case 'tank':
				tankWatchtower.animation.play('watchtower gradient color', true);
				foregroundSprites.forEach(function(spr:FlxSprite)
				{
					spr.animation.play('fg', true);
				});
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}

		if (isModStage) stageHandler.beatHit();

		scripts.executeFunc('beatHit', [curBeat]);
		if (FlxG.save.data.botplay)
			botplayTextBeat();
	}

	function botplayTextBeat()
	{ // added this cuz i think it would be cool if the botplay text zooms on the beat lol
		botplayTxt.scale.x += 0.1;
		botplayTxt.scale.y += 0.1;
	}

	var curLight:Int = 0;

	// used for scripting
	public static function setDeathCharacter(char:String = "bf", disableFlip:Bool = false)
	{
		GameOverSubstate.disableFlipX = disableFlip;
		GameOverSubstate.deathCharacter = char;
		TraceLog.addLogData("Set Death Character to: " + GameOverSubstate.deathCharacter);
		var txte:String = (GameOverSubstate.disableFlipX ? "disabled." : "enabled.");
		TraceLog.addLogData("Death Character FlipX was " + txte);
	}

	public static function setDeathSongBpm(bpm:Float = 100)
	{
		TraceLog.addLogData("Set Game Over song bpm to " + bpm);
		GameOverSubstate.songBpm = bpm;
	}

	public static function triggerEvent(nameShit:String, input1:String, input2:String)
	{
		TraceLog.addLogData("Triggering an event... " + nameShit);
		var s:ChartEvent = new ChartEvent(0, 0, false);
		s.EVENT_NAME = nameShit;
		s.value1 = input1;
		s.value2 = input2;

		executeEvents(s, s.EVENT_NAME, s.value1, s.value2);
	}
}

class PlayStateConfig
{
	/**
	 * Font that will be used for every text on playstate.
	 * must be the font name "VCR OSD Mono"
	 */
	public var uiTextFont:String = 'VCR OSD Mono';

	/**
	 * "Score: " text in PlayState.scoreTxt
	 */
	public var scoreText:String = 'Score';

	/**
	 * "Accuracy: " text in PlayState.scoreTxt
	 */
	public var accuracyText:String = 'Accuracy';

	/**
	 * "Misses: " text in PlayState.scoreTxt
	 */
	public var missesText:String = 'Misses';

	/**
	 * Set the color of the time bar!
	 */
	public var timeBarColor:Int = 0xFFFFFFFF;

	/**
	 * Set the camera of the Note Impacts!
	 */
	public var noteImpactsCamera:FlxCamera = null;

	/**
	 * Set the camera of the Rating Sprite!
	 * (including the combo counter sprites)
	 */
	public var ratingSpriteCamera:FlxCamera = null;

	public function new()
	{
	}

	public function resetConfig()
	{
		uiTextFont = 'VCR OSD Mono';
		scoreText = 'Score';
		missesText = 'Misses';
		accuracyText = 'Accuracy';
		timeBarColor = 0xFFFFFFFF;
		noteImpactsCamera = PlayState.camHUD;
		ratingSpriteCamera = PlayState.camHUD;
	}
}

// what are you looking for?
