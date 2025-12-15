class_name Tower;
extends Node2D;


var deployed := false;
var canPlace := false;

@export var towerTypeId: String;
var towerType: Dictionary;
var tier := 0;
var stats: Dictionary;

var currentTarget = null;


func _ready() -> void:
	if towerTypeId: setType(towerTypeId);

	# Starts off not opaque for placement
	$Sprite2D.modulate.a = 0.6;

func _process(_delta):
	if not deployed:
		checkPlacement();
	else:
		if is_instance_valid(currentTarget):
			look_at(currentTarget.position);
		else:
			try_get_closest_target();


func setType(typeId: String):
	towerTypeId = typeId;
	towerType = Game.data.towers[typeId];
	updateProperties();

func updateProperties():
	stats = towerType[tier];

	$CollisionArea.scale = Vector2(stats.size, stats.size);
	$RangeArea.scale = Vector2(stats.range, stats.range);
	$CooldownTimer.wait_time = 1 / stats.firerate;

func checkPlacement():
	if $CollisionArea.has_overlapping_areas():
		canPlace = false;
		$CollisionArea/Highlight.color = Game.consts.highlight.invalid;
	else:
		canPlace = true;
		$CollisionArea/Highlight.color = Game.consts.highlight.valid;

func place():
	if deployed: return ;

	deployed = true;
	$Sprite2D.modulate.a = 1;

func try_get_closest_target():
	if !deployed: return ;

	var closest = 1000;
	var closest_area = null;
	for area in $RangeArea.get_overlapping_areas():
		var dist = area.position.distance_to(position);
		if dist < closest:
			closest = dist;
			closest_area = area;

	if closest_area:
		currentTarget = closest_area.get_parent();

func _on_cooldown_timeout():
	if is_instance_valid(currentTarget):
		attack();
	else:
		try_get_closest_target();

func attack():
	pass ;
