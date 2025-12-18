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
	$AnimatedSprite2D.modulate.a = 0.6;

func _process(_delta):
	if not deployed:
		checkPlacement();
	else:
		try_get_closest_target();
		if is_instance_valid(currentTarget):
			look_at(currentTarget.global_position);


func setType(typeId: String):
	towerTypeId = typeId;
	towerType = Game.data.towers[typeId];
	updateProperties();

func updateProperties():
	stats = towerType.levels[tier];

	$CollisionArea.scale = Vector2(towerType.size, towerType.size);
	$RangeArea.scale = Vector2(stats.range, stats.range);
	$CooldownTimer.wait_time = 1 / stats.firerate;

func checkPlacement():
	if $CollisionArea.has_overlapping_areas():
		canPlace = false;
		_highlightCollider("invalid");
	else:
		canPlace = true;
		_highlightCollider("valid");

func place():
	if deployed: return ;

	deployed = true;
	$AnimatedSprite2D.modulate.a = 1;
	_highlightCollider("placed");

func try_get_closest_target():
	if !deployed: return ;

	var closest = 1000;
	var closest_area = null;
	for area in $RangeArea.get_overlapping_areas():
		var dist = area.global_position.distance_to(global_position);
		if dist < closest:
			closest = dist;
			closest_area = area;

	if closest_area:
		var target = closest_area.get_parent();
		if target.is_in_group("enemy"):
			currentTarget = target;
			return;

	currentTarget = null;

func _on_cooldown_timeout():
	if is_instance_valid(currentTarget):
		attack();

func attack():
	pass ;


# Utils

func _highlight(colorObject: Node, highType: String):
	colorObject.color = Game.consts.highlight[highType];

func _highlightCollider(highType: String):
	_highlight($CollisionArea/Highlight, highType);
