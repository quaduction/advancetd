extends Control;

@onready var anim = $AnimationPlayer;

func slide_away():
	anim.play("slide_out");
	await anim.animation_finished
