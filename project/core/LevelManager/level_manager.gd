class_name LevelManager;
extends Node2D;

signal levelLoaded(levelNode: Node);
signal levelUnloaded(levelNode: Node);

const MAPS_PATH := "res://levels/";
const HUD_PATH := "res://ui/hud/hud.tscn";

var currentLevel: Level = null;
var hud: Hud = null;

func playLevel(mapName: String):
	loadLevel(MAPS_PATH + "%s/%s.tscn" % [mapName, mapName]);

func loadLevel(levelSoup):
	currentLevel = SceneManager.bucketAttachInstance("activeLevel", self, levelSoup);
	hud = SceneManager.bucketAttachInstance("activeLevel", Game.menuManager, HUD_PATH);
	_mirror();

	currentLevel.levelEnd.connect(_on_level_end);

	levelLoaded.emit(currentLevel);

func unloadLevel():
	if type_string(typeof(currentLevel)) == "Node":
		currentLevel.levelEnd.disconnect(_on_level_end);

		SceneManager.freeBucket("activeLevel");
		currentLevel = null;
		_mirror();


		levelUnloaded.emit(currentLevel);

func _mirror():
	Game.currentLevel = currentLevel;
	Game.hud = hud;


func _on_level_end(won):
	unloadLevel();
	pass;
