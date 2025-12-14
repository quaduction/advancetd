extends StateHandler;

var gameMenuScreen;

func load():
	gameMenuScreen = preload("res://ui/gameMenuScreen/gameMenuScreen.tscn").instantiate();
	Game.menuManager.add_child(gameMenuScreen);

func handoff():
	gameMenuScreen.queue_free();