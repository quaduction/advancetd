extends Path2D;

@onready var level = get_parent() as Level;

func reachedBase(goon: PathEnemy):
	level.damageBase(goon.baseDamage);
