class_name ProjectileTower;
extends Tower;

@export var bullet := preload("./bullet/base_bullet.tscn");

@onready var shootSfx := $shoot;
@onready var animation := $AnimatedSprite2D;

var firing := false;

func attack():
	if firing:
		return;

	firing = true;

	animation.play("firing");
	shootSfx.play();

	var projectile = bullet.instantiate();
	projectile.init(self, currentTarget.position);

	Game.currentLevel.projectiles.add_child(projectile);

	await get_tree().create_timer(0.2).timeout;

	animation.play("default");
	firing = false;
