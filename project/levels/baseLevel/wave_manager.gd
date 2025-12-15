extends Path2D;


@export var enemy_type_1: PackedScene
@export var enemy_type_2: PackedScene
@export var enemy_type_3: PackedScene
@export var enemy_type_4: PackedScene

var spawn_interval := 1.0;
var enemies_to_spawn := [];
var goons;
var kills := 0;

@onready var level = get_parent() as Level;

func _ready() -> void:
	goons = enemies_to_spawn.size();

func reachedBase(goon: PathEnemy):
	level.damageBase(goon.baseDamage);

func eliminated(goon: PathEnemy):
	kills += 1;
	level.mutBal(goon.cashYield);

	checkWin();


func checkWin():
	if kills >= goons:
		level.gameOver(true);
