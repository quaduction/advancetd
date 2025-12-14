extends TextureButton;

func _on_pressed() -> void:
	Game.main.changeState(Game.states.LEVEL_SELECT);
