extends TextureButton


func _on_pressed() -> void:
	Game.main.changeState(Game.states.LOADOUT_SELECT);
