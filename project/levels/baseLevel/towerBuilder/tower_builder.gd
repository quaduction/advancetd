extends Node2D;


var current_tower: Tower = null;
var is_placing: bool = false;

signal placementEnd(success: bool);


func place(tower: Tower) -> bool:
	startPlacement(tower);

	return await placementEnd;

func startPlacement(tower: Tower) -> void:
	# Cancel any existing placement
	cancel();

	current_tower = tower;
	is_placing = true;

	# Add the tower to the scene so it can follow the mouse
	add_child(current_tower);


func _process(_delta: float) -> void:
	if not is_placing or current_tower == null: return ;

	# Follow mouse cursor
	current_tower.global_position = get_global_mouse_position();

func _unhandled_input(event: InputEvent) -> void:
	if not is_placing or current_tower == null: return ;

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			_attempt_place();
		elif event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			cancel();

func _attempt_place() -> void:
	if current_tower.canPlace:
		is_placing = false;

		# Detach from builder (optional but clean)
		# current_tower.reparent(get_tree().current_scene)

		# Call the tower's place method
		if current_tower.has_method("place"):
			current_tower.place();

		# Announce successful placement
		placementEnd.emit(true);

		current_tower = null;
		
func cancel() -> void:
	if current_tower: current_tower.queue_free();

	# Announce unsuccessful placement
	placementEnd.emit(false);

	current_tower = null;
	is_placing = false;
