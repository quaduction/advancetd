extends Node2D;

signal levelLoaded(levelNode: Node);
signal levelUnloaded(levelNode: Node);

var currentLevel: Node;

func load(levelSoup):
    currentLevel = SceneManager.bucketAttachInstance("activeLevel", self, levelSoup);
    levelLoaded.emit(currentLevel);

func unload():
    if type_string(typeof(currentLevel)) == "Node":
        levelUnloaded.emit(currentLevel);
        SceneManager.freeBucket("activeLevel");