extends StateHandler;

var mainMenu;

func load():
	mainMenu = preload("res://ui/titleScreen/titleScreen.tscn").instantiate();
	Game.menuManager.add_child(mainMenu);

func handoff():
	mainMenu.queue_free();
