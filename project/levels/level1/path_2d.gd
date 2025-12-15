extends "res://levels/baseLevel/wave_manager.gd"

@export var enemy_type_1: PackedScene
@export var enemy_type_2: PackedScene
@export var enemy_type_3: PackedScene
@export var enemy_type_4: PackedScene

var spawn_interval := 1.0
var enemies_to_spawn := []

func _ready():
	enemies_to_spawn = [
		enemy_type_1, enemy_type_1, enemy_type_2, 
		enemy_type_3, enemy_type_4, enemy_type_1, enemy_type_1, enemy_type_2, 
		enemy_type_3, enemy_type_4, enemy_type_1, enemy_type_1, enemy_type_2, 
		enemy_type_3, enemy_type_4, enemy_type_1, enemy_type_1, enemy_type_2, 
		enemy_type_3, enemy_type_4
	]
	start_wave()

func start_wave():
	if enemies_to_spawn.size() > 0:
		spawn_enemy(enemies_to_spawn.pop_front())
		await get_tree().create_timer(spawn_interval).timeout
		start_wave()

func spawn_enemy(enemy_scene: PackedScene):
	if enemy_scene == null:
		return
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = self.position
	if enemy_instance.has_method("set_path"):
		enemy_instance.set_path(self)
	if enemy_instance.has_signal("reached_base"):
		enemy_instance.reached_base.connect(_on_enemy_reached_base)
	add_child(enemy_instance)

func _on_enemy_reached_base(enemy):
	level.damageBase(enemy.baseDamage)
	enemy.queue_free()
