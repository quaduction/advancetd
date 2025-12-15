extends StateHandler;

func load():
	print("Started level: ", Game.currentLevel);

	awaitGameOver();

func handoff():
	Game.levelManager.unloadLevel();

func awaitGameOver():
	var levelWin = await Game.levelManager.levelEnded;
	print("Level won? ", levelWin);

	Game.main.changeState(Game.states.LEVEL_SELECT);