extends StateHandler;

var loadoutScreen;

func load():
	loadoutScreen = preload("res://ui/loadoutScreen/loadoutScreen.tscn").instantiate();
	Game.menuManager.add_child(loadoutScreen);

func handoff():
	loadoutScreen.queue_free();