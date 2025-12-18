extends "res://levels/baseLevel/wave_manager.gd"

func _ready():
	wave_delay = 10.0;
	initial_wave_delay = 5.0;

	startWithWaves([
		[1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1],
		[4, 4, 4],
		[3, 1, 1],
		[2, 3, 3]
	]);
