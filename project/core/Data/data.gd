class_name Data;
extends Node;

@export var credits := 100;

const TOWER_DATA := "res://common/data/towers.json";
var towers: Dictionary = {};
var towersOwned: Dictionary = {};
var towersEquipped: Array = [];

func _ready() -> void:
	towersEquipped.resize(6);

	loadTowerDefinitions();

func loadTowerDefinitions() -> void:
	if not towers.is_empty(): return ;

	var file := FileAccess.open(TOWER_DATA, FileAccess.READ);
	var json: Dictionary = JSON.parse_string(file.get_as_text());
	var tower_array: Array = json["towers"];

	for tower: Dictionary in tower_array:
		var id: String = tower["id"];

		towers[id] = tower;

		towersOwned[id] = false;
