extends "res://levels/baseLevel/wave_manager.gd"

const WAVE_DELAY := 7.5
const INITIAL_WAVE_DELAY := 3.0

func _ready():
	wave_delay = 7.5;
	initial_wave_delay = 3.0;

	startWithWaves([
		[1, 1, 1, 1],
		[1, 1],
		[4, 4, 4],
		[3, 1, 1],
		[2, 3, 3],
		[4, 4, 4, 4, 4, 4],
		[1, 4, 1, 4, 1, 4, 1, 4, 1],
		[3, 3, 3, 2, 2, 2, 2, 2],
		[1, 1, 1, 1, 1]
	]);
