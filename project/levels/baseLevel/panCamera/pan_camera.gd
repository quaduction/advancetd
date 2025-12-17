extends Camera2D;

@export var zoom_speed := 0.1;
@export var min_zoom := Vector2.ONE;
@export var max_zoom := Vector2(2.0, 2.0);

var zoom_level := Vector2.ONE;
var is_panning := false;
var last_mouse_pos := Vector2.ZERO;

var bounds_rect: Rect2

func _ready():
	# Define the "original viewport bounds" in world space
	var vp_size := get_viewport_rect().size
	bounds_rect = Rect2(
		global_position,
		vp_size
	)

func _unhandled_input(_event):
	#
	# Zooming
	#
	if Input.is_action_just_pressed("zoom_out") or Input.is_action_just_pressed("zoom_in"):
		var mouse_world_before := get_global_mouse_position()

		if Input.is_action_just_pressed("zoom_out"):
			zoom_level -= Vector2(zoom_speed, zoom_speed);
		elif Input.is_action_just_pressed("zoom_in"):
			zoom_level += Vector2(zoom_speed, zoom_speed);

		zoom_level = zoom_level.clamp(min_zoom, max_zoom);
		zoom = zoom_level;

		var mouse_world_after := get_global_mouse_position();
		position += mouse_world_before - mouse_world_after;

	# 
	# Panning
	#
	if Input.is_action_pressed("pan"):
		var mouse_pos := get_viewport().get_mouse_position();

		if !is_panning:
			is_panning = true;
			last_mouse_pos = mouse_pos;

		var delta := mouse_pos - last_mouse_pos;
		position -= delta / zoom;
		last_mouse_pos = mouse_pos;

	if Input.is_action_just_released("pan"):
		is_panning = false;

	_conform_to_bounds();

func _conform_to_bounds():
	var vp_size := get_viewport_rect().size;
	var visible_size := vp_size / zoom;

	var min_pos := bounds_rect.position;
	var max_pos := bounds_rect.position + bounds_rect.size - visible_size;

	global_position.x = clamp(global_position.x, min_pos.x, max_pos.x);
	global_position.y = clamp(global_position.y, min_pos.y, max_pos.y);
