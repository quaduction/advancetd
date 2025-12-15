class_name PathEnemy;
extends PathFollow2D;

@export var cashYield := 10;
@export var hp := 10.0;
@export var baseDamage := 5.0;
@export var speed := 1.0;
var isDestroyed := false;

func _ready():
	add_to_group("enemy");

func _process(_delta):
	#Move
	progress_ratio += 0.0005 * speed
	if progress_ratio == 1:
		pathFinished()
		return ;

func pathFinished():
	if isDestroyed: return ;
	isDestroyed = true;

	get_parent().reachedBase(self);

	queue_free();

func takeDamage(damage):
	if isDestroyed: return ;
	
	hp -= damage
	damage_animation()
	if hp <= 0:
		isDestroyed = true;

		get_parent().eliminated(self);

		queue_free();

func damage_animation():
	var tween := create_tween()
	tween.tween_property(self, "v_offset", 0, 0.05)
	tween.tween_property(self, "modulate", Color.ORANGE_RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	tween.set_parallel()
	tween.tween_property(self, "v_offset", -5, 0.2)
	tween.set_parallel(false)
	tween.tween_property(self, "v_offset", 0, 0.2)
