extends TextureButton;


func _on_pressed() -> void:
	Game.main.changeState(Game.states.MAIN_MENU);
