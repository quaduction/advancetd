class_name Data;
extends Node;

@export var credits := 100;

const TOWERS := "res://common/data/towers.json";
var towers: Dictionary = {}
var towersOwned: Dictionary = {}
var towersEquipped: Array = [];

func _ready() -> void:
	towersEquipped.resize(6);

	loadTowerDefinitions();

func loadTowerDefinitions() -> void:
	if not towers.is_empty(): return ;

	var file := FileAccess.open(TOWERS, FileAccess.READ);
	var json: Dictionary = JSON.parse_string(file.get_as_text());
	var tower_array: Array = json["towers"];

	for tower: Dictionary in tower_array:
		var id: String = tower["id"];

		towers[id] = {
			"name": tower["name"],
			"price": tower["credit_price"],
			"scale": tower.get("scale", 1.0)
		};

		towersOwned[id] = false;