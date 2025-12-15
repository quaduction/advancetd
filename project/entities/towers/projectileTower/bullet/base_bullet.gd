class_name Bullet;
extends Node2D;


@export var speed: float = 800.0;
@export var pierce: int = 1;
@export var time: float = 1.0;

var damage: float;

var direction := Vector2.ZERO;

func init(tower: ProjectileTower, target):
	damage = tower.stats.damage;

	position = tower.position;
	direction = (target - position).normalized();

func _ready() -> void:
	$DespawnTimer.wait_time = time;

func _process(delta):
	position += direction * speed * delta;

func _on_area_2d_area_entered(area):
	var obj = area.get_parent();

	if obj.is_in_group("enemy"):
		pierce -= 1;
		obj.takeDamage(damage);

	if pierce == 0:
		queue_free();

func _on_despawn_timer_timeout():
	queue_free();
