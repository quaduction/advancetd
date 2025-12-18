extends Path2D;


@export var enemy_type_1: PackedScene;
@export var enemy_type_2: PackedScene;
@export var enemy_type_3: PackedScene;
@export var enemy_type_4: PackedScene;

@export var spawn_interval := 1.0;
@export var wave_delay := 10.0;
@export var initial_wave_delay := 3.0;

var waves := [];
var remainingWaves := 0;

@onready var level = get_parent() as Level;
	

func startWithWaves(queue: Array):
	waves = queue;
	remainingWaves = waves.size();
	start_waves();

func start_waves():
	await get_tree().create_timer(initial_wave_delay).timeout;

	for wave in waves:
		var queue := []
		for enemy_id in wave:
			match enemy_id:
				1: queue.append(enemy_type_1);
				2: queue.append(enemy_type_2);
				3: queue.append(enemy_type_3);
				4: queue.append(enemy_type_4);

		await send_wave(queue);
		remainingWaves -= 1;
		
		await get_tree().create_timer(wave_delay).timeout;

func send_wave(queue):
	for enemy in queue:
		spawn_enemy(enemy);
		await get_tree().create_timer(spawn_interval).timeout;

func spawn_enemy(goonScene: PackedScene):
	if goonScene == null: return ;
	var goon = goonScene.instantiate() as PathEnemy;

	goon.reachedBase.connect(reachedBase);
	goon.eliminated.connect(eliminated);
	
	add_child(goon);

func reachedBase(goon: PathEnemy):
	level.damageBase(goon.baseDamage);
	goon.queue_free();

func eliminated(goon: PathEnemy):
	remove_child(goon);

	level.mutBal(goon.cashYield);

	checkWin();

func activeEnemies() -> int:
	return get_children().size();

func checkWin():
	print("Active enemies: %s   Queue length: %s" % [activeEnemies(), remainingWaves])
	if activeEnemies() == 0 && remainingWaves == 0:
		level.gameOver(true);
