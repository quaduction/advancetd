extends "res://levels/baseLevel/wave_manager.gd"

func _ready():
	wave_delay = 7.5;
	initial_wave_delay = 3.0;

	startWithWaves([
		[3, 3, 3],
		[4, 4],
		[4, 3, 4, 3],
		[4, 1, 1, 4, 1, 1, 4],
		[2, 2, 4, 4],
		[4, 4, 4, 4, 4, 4],
		[1, 4, 1, 4, 1, 4, 1, 4, 1],
		[3, 3, 3, 2, 2, 2, 2, 2],
		[1, 1, 1, 1, 1]
	])
