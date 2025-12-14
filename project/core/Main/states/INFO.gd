extends StateHandler;

var infoScreen;

func load():
	infoScreen = preload("res://ui/infoScreen/infoScreen.tscn").instantiate();
	Game.menuManager.add_child(infoScreen);

func handoff():
	infoScreen.queue_free();