class_name Data;
extends Node;

@export var credits := 100;
var towers: Dictionary = {}
var towersOwned: Dictionary = {}
var towersEquipped: Array = [];

func _ready() -> void:
	towersEquipped.resize(6);
