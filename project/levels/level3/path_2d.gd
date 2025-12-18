extends "res://levels/baseLevel/wave_manager.gd"

const WAVE_DELAY := 7.5
const INITIAL_WAVE_DELAY := 3.0

func _ready():
	await start_waves()

func start_waves() -> void:
	await get_tree().create_timer(INITIAL_WAVE_DELAY).timeout

	# 1 - rover
	# 2 - tank large
	# 3 - mecha
	# 4 - tank
	var waves = [
		[3, 3, 3],
		[4, 4],
		[4, 3, 4, 3],
		[4, 1, 1, 4, 1, 1, 4],
		[2, 2, 4, 4],
		[4, 4, 4, 4, 4, 4],
		[1, 4, 1, 4, 1, 4, 1, 4, 1],
		[3, 3, 3, 2, 2, 2, 2, 2],
		[1, 1, 1, 1, 1]
	]

	for wave in waves:
		var queue := []
		for enemy_id in wave:
			match enemy_id:
				1:
					queue.append(enemy_type_1)
				2:
					queue.append(enemy_type_2)
				3:
					queue.append(enemy_type_3)
				4:
					queue.append(enemy_type_4)
		setEnemyQueue(queue)
		await get_tree().create_timer(WAVE_DELAY).timeout
