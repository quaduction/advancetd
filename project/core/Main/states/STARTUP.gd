extends StateHandler;

var startupScreen := preload("res://ui/startupScreen/startup_screen.tscn").instantiate();

func load():
	Game.menuManager.add_child(startupScreen);

	Game.main.changeState(Game.main.State.MAIN_MENU);

func handoff():
	await startupScreen.slide_away();

	startupScreen.queue_free();
