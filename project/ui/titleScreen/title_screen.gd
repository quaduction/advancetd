extends Control;


func _on_play_pressed() -> void:
	Game.main.changeState(Game.states.LOADOUT_SELECT);

func _on_settings_pressed() -> void:
	Game.main.changeState(Game.states.SETTINGS);

func _on_info_pressed() -> void:
	Game.main.changeState(Game.states.INFO);
