class_name ProjectileTower;
extends Tower;

@export var bullet := preload("./bullet/base_bullet.tscn");

func attack():
	var projectile = bullet.instantiate();
	projectile.init(self, currentTarget);

	Game.currentLevel.projectiles.add_child(projectile);
