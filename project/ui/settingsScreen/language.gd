extends TextureButton

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	var current := TranslationServer.get_locale()

	if current.begins_with("fr"):
		TranslationServer.set_locale("en")
	else:
		TranslationServer.set_locale("fr")
