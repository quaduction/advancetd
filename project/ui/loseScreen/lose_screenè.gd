extends Control


func _on_return_pressed() -> void:
	Game.main.changeState(Game.states.MAIN_MENU);
