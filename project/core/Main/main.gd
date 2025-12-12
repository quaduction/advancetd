class_name Main;
extends Node;

signal stateTransition(newState);

enum State {
	VOID,
	STARTUP,
	MAIN_MENU,
	SETTINGS,
	INFO,
	LEVEL_SELECT,
	LOADOUT_SELECT,
	LEVEL_PLAY,
	PAUSE
};

var state: State = State.VOID;
var newState: State = State.STARTUP;

var states: Dictionary[State, StateHandler] = {};

@warning_ignore_start("shadowed_global_identifier")
@onready var LevelManager := $LevelManager;
@onready var MenuManager := $MenuManager;
@onready var Data := $Data;
@warning_ignore_restore("shadowed_global_identifier")

func _ready():
	# Uplink to the global autoload
	Game.main = self;
	Game.levelManager = LevelManager;
	Game.menuManager = MenuManager;
	Game.data = Data;

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
			@warning_ignore("redundant_await")
			await states[state].run(self);
			
			if newState != state:
				await transitionStates();
				stateTransition.emit(state);

		await get_tree().process_frame;



func transitionStates():
	if !(states.has(state) && states.has(newState)): return;

	var bakNewState = newState; # Prevent "redirector" states from getting skipped over

	await states[state].unload();

	await states[bakNewState].load();

	print(states[state], states[state].handoff);
	await states[state].handoff();

	state = bakNewState;


func changeState(toState: State) -> void:
	if newState == state: return;

	newState = toState;