class_name Main;
extends Node;

signal stateTransition(newState);

enum State {
	STARTUP,
	MAIN_MENU,
	SETTINGS,
	INFO,
	LEVEL_SELECT,
	LOADOUT_SELECT,
	LEVEL_PLAY,
	PAUSE
};

var state: State = State.STARTUP;
var stateIsNew := false;
var states: Dictionary[State, StateHandler] = {};

@onready var LevelManager := $LevelManager;
@onready var MenuManager := $MenuManager;

func _ready():
	# Uplink to the global autoload
	Game.main = self;
	Game.levelManager = LevelManager;
	Game.menuManager = MenuManager;

	# Start state machine
	_load_states();
	call_deferred("_run_state_machine");

func _load_states():
	var base_path = "res://core/Main/states/";

	for state_name in State.keys():
		var path = base_path + state_name + ".gd";

		if ResourceLoader.exists(path):
			var script = load(path);
			states[State[state_name]] = script.new();
		else:
			push_warning("State script not found: " + path);


func _run_state_machine() -> void:
	while true:
		if states.has(state):
			var prerunState = state;

			@warning_ignore("redundant_await")
			await states[state].run(self);

			var postrunState = state;
			
			if stateIsNew && prerunState == postrunState:
				print("why is it herer", State.keys()[state])
				stateIsNew = false;
				stateTransition.emit(state);
		await get_tree().process_frame;


func changeState(newState: State) -> void:
	if newState == state: return;

	stateIsNew = true;
	state = newState;