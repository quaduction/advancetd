extends Path2D;


@export var enemy_type_1: PackedScene
@export var enemy_type_2: PackedScene
@export var enemy_type_3: PackedScene
@export var enemy_type_4: PackedScene

@export var spawn_interval := 1.0;
var enemies_to_spawn := [];
var goons;
var kills := 0;

@onready var level = get_parent() as Level;
	

func setEnemyQueue(queue: Array):
	enemies_to_spawn = queue;
	goons = enemies_to_spawn.size();
	start_wave();

func start_wave():
	if enemies_to_spawn.size() > 0:
		spawn_enemy(enemies_to_spawn.pop_front());
		await get_tree().create_timer(spawn_interval).timeout;
		start_wave();

func spawn_enemy(goonScene: PackedScene):
	if goonScene == null: return;
	var goon = goonScene.instantiate() as PathEnemy;

	# enemy_instance.global_position = self.position

	goon.reachedBase.connect(reachedBase);
	goon.eliminated.connect(eliminated);
	
	add_child(goon);

func reachedBase(goon: PathEnemy):
	kills += 1;
	level.damageBase(goon.baseDamage);
	goon.queue_free();

func eliminated(goon: PathEnemy):
	kills += 1;
	level.mutBal(goon.cashYield);

	checkWin();

func checkWin():
	if kills >= goons:
		level.gameOver(true);
