extends TextureButton;

func _on_pressed() -> void:
	var tower = preload("res://entities/towers/scout/scout.tscn").instantiate();
	$"../TowerBuilder".startPlacement(tower);
