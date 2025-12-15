extends Control

signal fateAccepted();

func _on_return_pressed() -> void:
	fateAccepted.emit();
