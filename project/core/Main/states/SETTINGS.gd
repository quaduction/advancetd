extends StateHandler;

var settingsScreen;

func load():
	settingsScreen = preload("res://ui/settingsScreen/settingsScreen.tscn").instantiate();
	Game.menuManager.add_child(settingsScreen);

func handoff():
	settingsScreen.queue_free();