extends "res://levels/baseLevel/wave_manager.gd"

func _ready():
	wave_delay = 10.0;
	initial_wave_delay = 3.0;

	startWithWaves([
		[1, 1, 1, 3],
		[1, 1, 4, 4],
		[3, 3, 3, 1, 1, 4],
		[2, 1, 1],
		[4, 4, 4, 4],
		[3, 3, 4, 4, 2],
		[1, 1, 1, 1, 1]
	]);
