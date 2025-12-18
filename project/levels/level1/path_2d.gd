extends "res://levels/baseLevel/wave_manager.gd"

const WAVE_DELAY := 10.0
const INITIAL_WAVE_DELAY := 5.0

func _ready():
	await start_waves()

func start_waves() -> void:
	await get_tree().create_timer(INITIAL_WAVE_DELAY).timeout
	
	# 1 - rover
	# 2 - tank large
	# 3 - mecha
	# 4 - tank
	var waves = [
		[1, 1, 1, 1],
		[1, 1],
		[4, 4, 4],
		[3, 1, 1],
		[2, 3, 3]
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
