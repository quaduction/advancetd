extends Control

const ICON := "res://common/assets/textures/sprites/towers/"

@onready var terminal_text: RichTextLabel = $Terminal/RichTextLabel
@onready var terminal_balance: RichTextLabel = $Terminal/Balance

@onready var shop_container := $Shop/ShopContainer
@onready var tower_container := $TowerSlots/TowerContainer

@onready var selectSfx := $SelectPlayer

var selected_tower: String = ""

func _ready() -> void:
	connect_shop_slots()
	connect_tower_slots()
	refresh_ui()

	show_message(
		"[color=gray]Click a tower to purchase or select. "
		+ "Then click a slot to equip.[/color]"
	)

func refresh_ui() -> void:
	refresh_shop_ui()
	refresh_tower_slots_ui()
	refresh_terminal()

func refresh_terminal() -> void:
	terminal_balance.text = "Balance: [color=gold]%d⋲[/color]" % Game.data.credits

func refresh_shop_ui() -> void:
	var tower_ids: Array = Game.data.towers.keys()
	var index: int = 0

	for row in shop_container.get_children():
		for slot in row.get_children():
			if index >= tower_ids.size():
				slot.visible = false
				continue

			slot.visible = true
			var id: String = tower_ids[index]
			index += 1

			slot.set_meta("tower_id", id)

			var name_label: RichTextLabel = slot.get_node("TowerLabel")
			var price_label: RichTextLabel = slot.get_node("PriceLabel")
			var icon: TextureRect = slot.get_node("TowerIcon")

			name_label.text = Game.data.towers[id].name

			if Game.data.towersOwned[id]:
				price_label.text = "Owned"
			else:
				price_label.text = "%d⋲" % Game.data.towers[id].credit_price

			apply_tower_icon(icon, id)

func refresh_tower_slots_ui() -> void:
	var slot_nodes = tower_container.get_children()

	for i in slot_nodes.size():
		var slot_node = slot_nodes[i]
		var label: RichTextLabel = slot_node.get_node("RichTextLabel")
		var icon: TextureRect = slot_node.get_node("TowerIcon")

		if Game.data.towersEquipped[i] != null:
			var id: String = Game.data.towersEquipped[i]
			label.text = Game.data.towers[id].name
			apply_tower_icon(icon, id)
		else:
			label.text = ""
			icon.texture = null

func apply_tower_icon(icon: TextureRect, id: String) -> void:
	icon.texture = load(ICON + id + ".tres")
	icon.expand = true
	icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED

	var scale_value: float = float(Game.data.towers[id].display_scale)
	icon.scale = Vector2(scale_value, scale_value)
	icon.pivot_offset = icon.size * 0.5

func set_slot_hover(slot: Control, value: float) -> void:
	var mat := slot.material
	if mat == null:
		return
	if mat is ShaderMaterial:
		mat.set_shader_parameter("size_effect", value)

func show_message(text: String) -> void:
	terminal_text.text = text
	refresh_terminal()
	selectSfx.play()

func connect_shop_slots() -> void:
	for row in shop_container.get_children():
		for slot in row.get_children():
			slot.mouse_entered.connect(
				func():
					set_slot_hover(slot, 5)
			)
			slot.mouse_exited.connect(
				func():
					set_slot_hover(slot, 0.0)
			)
			slot.gui_input.connect(
				func(event):
					if event is InputEventMouseButton and event.pressed:
						handle_shop_click(slot)
			)

func connect_tower_slots() -> void:
	var slot_nodes = tower_container.get_children()
	for i in slot_nodes.size():
		var slot_node = slot_nodes[i]

		slot_node.mouse_entered.connect(
			func():
				set_slot_hover(slot_node, 5)
		)
		slot_node.mouse_exited.connect(
			func():
				set_slot_hover(slot_node, 0.0)
		)
		slot_node.gui_input.connect(
			func(event):
				if event is InputEventMouseButton and event.pressed:
					handle_tower_slot_click(i)
		)

func handle_shop_click(slot) -> void:
	var id: String = slot.get_meta("tower_id")

	if Game.data.towersOwned[id]:
		selected_tower = id
		show_message("[color=gray]Selected %s[/color]" % Game.data.towers[id].name)
		return

	var price: int = Game.data.towers[id].credit_price
	if Game.data.credits < price:
		show_message("[color=red]Not enough balance[/color]")
		return

	Game.data.credits -= price
	Game.data.towersOwned[id] = true
	selected_tower = id

	show_message("[color=gray]Purchased %s[/color]" % Game.data.towers[id].name)
	refresh_ui()

func handle_tower_slot_click(slot_index: int) -> void:
	if Game.data.towersEquipped[slot_index] != null:
		var id: String = Game.data.towersEquipped[slot_index]
		Game.data.towersEquipped[slot_index] = null

		show_message("[color=gray]Removed %s[/color]" % Game.data.towers[id].name)
		refresh_tower_slots_ui()
		return

	if selected_tower == "":
		show_message("[color=yellow]No tower selected[/color]")
		return

	if not Game.data.towersOwned[selected_tower]:
		show_message("[color=red]Tower not owned[/color]")
		return

	if Game.data.towersEquipped.has(selected_tower):
		show_message(
			"[color=orange]%s is already equipped[/color]"
			% Game.data.towers[selected_tower].name
		)
		return

	Game.data.towersEquipped[slot_index] = selected_tower

	show_message("[color=gray]Equipped %s[/color]" % Game.data.towers[selected_tower].name)
	refresh_tower_slots_ui()
