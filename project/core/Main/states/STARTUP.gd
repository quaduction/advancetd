extends StateHandler;

var startupScreen := preload("res://ui/startupScreen/startup_screen.tscn").instantiate();

func load():
	Game.menuManager.add_child(startupScreen);

	Game.main.changeState(Game.main.State.MAIN_MENU);

	print("finished load");

func handoff():
	print("whuh")
	await startupScreen.slide_away();
	print("over and out")
	startupScreen.queue_free();