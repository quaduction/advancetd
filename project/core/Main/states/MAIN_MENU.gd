extends StateHandler;

var mainMenu;

func load():
	print("transition to main menu");

	mainMenu = preload("res://ui/titleScreen/titleScreen.tscn").instantiate();
	Game.menuManager.add_child(mainMenu);