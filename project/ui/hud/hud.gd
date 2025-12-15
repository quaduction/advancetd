class_name Hud;
extends Control;


const ICON := "res://common/assets/textures/sprites/towers/";

func _ready() -> void:
	await Game.levelManager.levelLoaded;
	refresh_loadout_bar_ui();
	connect_tower_slots();

func _process(_delta):
	refresh_info_ui();

func refresh_loadout_bar_ui() -> void:
	var tower_ids := Game.data.towersEquipped;
	var slots = $TowerSlot.get_children();
	var slotIndex := 0;

	for slot in slots:
		slot.visible = false;

	for index in tower_ids.size():
		var slot = slots[slotIndex];
		var id = tower_ids[index];

		index += 1;
		if id == null: continue ;
		slot.visible = true;
		slotIndex += 1;

		slot.set_meta("tower_id", id);

		var name_label: RichTextLabel = slot.get_node("TowerLabel");
		var price_label: RichTextLabel = slot.get_node("PriceLabel");
		var icon: TextureRect = slot.get_node("TowerIcon");

		if id == null:
			name_label.text = "";
			price_label.text = "";
			slot.modulate.a = 0.1;
		else:
			name_label.text = Game.data.towers[id].name;

			var price = Game.data.towers[id].cash_price
			price_label.text = "[color=%s]$%d[/color]" % [
				"white" if price < Game.currentLevel.cash else "red",
				price
			];
			slot.modulate.a = 1;
			apply_tower_icon(icon, id);

func refresh_info_ui():
	var balLabel = $TopSheet/Row1/LeftRow/BalanceLabel;
	var waveLabel = $TopSheet/Row1/LeftRow/WaveLabel;
	var hpLabel = $TopSheet/Row1/RightRow/HealthLabel;
	var timeLabel = $TopSheet/Row1/RightRow/TimerLabel;

	balLabel.text = "Balance: %d⋔" % Game.currentLevel.cash;
	hpLabel.text = "Health: %d" % Game.currentLevel.baseHealth;

#
# Handlers
#

func connect_tower_slots():
	for slot in $TowerSlot.get_children():
		slot.mouse_entered.connect(
			func():
				set_hover(slot, 5);
		);
		slot.mouse_exited.connect(
			func():
				set_hover(slot, 0.0);
		);
		slot.gui_input.connect(
			func(event):
				if event is InputEventMouseButton and event.pressed:
					handle_loadout_click(slot);
		);

func handle_loadout_click(slot):
	var id: String = slot.get_meta("tower_id");

	var tower = load("res://entities/towers/%s/%s.tscn" % [id, id]).instantiate();
	Game.currentLevel.towerBuilder.startPlacement(tower);

#
# Utils
#

func apply_tower_icon(icon: TextureRect, id: String) -> void:
	icon.texture = load(ICON + id + ".tres");
	icon.expand = true;
	icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED;

	var scale_value: float = float(Game.data.towers[id].display_scale);
	icon.scale = Vector2(scale_value, scale_value);
	icon.pivot_offset = icon.size * 0.5;

func set_hover(slot: Control, value: float) -> void:
	if slot.material != null:
		slot.material.set_shader_parameter("size_effect", value);
