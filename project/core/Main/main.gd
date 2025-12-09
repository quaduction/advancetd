extends Node;

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
var states: Dictionary[State, StateHandler] = {};

@onready var LevelManager := $LevelManager;
@onready var MenuManager := $MenuManager;

func _ready():
	# Uplink to the global autoload
	Game.Main = self;
	Game.LevelManager = LevelManager;
	Game.MenuManager = MenuManager;

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
		await get_tree().process_frame;
