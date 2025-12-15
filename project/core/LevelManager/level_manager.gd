class_name LevelManager;
extends Node2D;

signal levelLoaded(levelNode: Node);
signal levelUnloaded(levelNode: Node);

const MAPS_PATH := "res://levels/";

var currentLevel: Node = null;

func playLevel(mapName: String):
	loadLevel(MAPS_PATH + "%s/%s.tscn" % [mapName, mapName]);
	# await levelLoaded;

func loadLevel(levelSoup):
	currentLevel = SceneManager.bucketAttachInstance("activeLevel", self, levelSoup);
	_mirror();

	levelLoaded.emit(currentLevel);

func unloadLevel():
	if type_string(typeof(currentLevel)) == "Node":
		SceneManager.freeBucket("activeLevel");
		currentLevel = null;
		_mirror();

		levelUnloaded.emit(currentLevel);

func _mirror():
	Game.currentLevel = currentLevel;
