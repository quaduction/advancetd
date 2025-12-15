extends Area2D;

# The stupid solution that works
func _process(_delta: float) -> void:
  rotation = -owner.rotation;