extends Control;


func _on_play_pressed() -> void:
	Game.main.changeState(Game.states.LEVEL_SELECT);

func _on_settings_pressed() -> void:
	Game.main.changeState(Game.states.SETTINGS);

func _on_info_pressed() -> void:
	Game.main.changeState(Game.states.INFO);
