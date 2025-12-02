extends Node2D

signal levelLoaded(levelNode: Node);
signal levelUnloaded(levelNode: Node);

var currentLevel: Node;

func load(levelInstanceSoup):
    pass;

func unload():
    if type_string(typeof(currentLevel)) == "Node":
        levelUnloaded.emit(currentLevel);
        currentLevel.queue_free();