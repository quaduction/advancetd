class_name ProjectileTower;
extends Tower;

@export var bullet := preload("./bullet/base_bullet.tscn");
@onready var shootSfx := $shoot;

func attack():
	var projectile = bullet.instantiate();
	projectile.init(self, currentTarget.position);
	shootSfx.play()

	Game.currentLevel.projectiles.add_child(projectile);
