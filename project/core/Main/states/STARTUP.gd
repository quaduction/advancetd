extends StateHandler;

var startupScreen := preload("res://ui/startupScreen/startup_screen.tscn").instantiate();

func run(main: Main):
	Game.menuManager.add_child(startupScreen);

	main.changeState(main.State.MAIN_MENU);
	animOut();

	print("finished run");

func animOut():
	if !await Game.main.stateTransition == Game.main.State.MAIN_MENU: return;
	
	await startupScreen.slide_away();
	print("over and out")
	startupScreen.queue_free();