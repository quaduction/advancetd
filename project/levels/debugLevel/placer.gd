extends TextureButton;

func _on_pressed() -> void:
	var tower = preload("res://entities/towers/soldier/soldier.tscn").instantiate();
	$"../TowerBuilder".startPlacement(tower);
