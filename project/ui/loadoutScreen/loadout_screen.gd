extends Control

const TOWERS_JSON := "res://common/data/towers.json"
const ICON_PATH := "res://common/assets/textures/sprites/towers/"

var towers: Dictionary = {}
var towersOwned: Dictionary = {}
var towersEquipped: Dictionary = {}
#var balance: int = 500
var selected_tower: String = ""

@onready var terminalText: RichTextLabel = $Terminal/RichTextLabel
@onready var terminalBalance: RichTextLabel = $Terminal/Balance

@onready var shop_container := $Shop/ShopContainer
@onready var tower_container := $TowerSlots/TowerContainer

func _ready() -> void:
	load_towers()
	load_shop()
	connect_tower_slots()
	updateTerminal("Click on a tower to purchase or select. With one selected, click on a tower slot to equip.")

func load_towers():
	var file: FileAccess = FileAccess.open(TOWERS_JSON, FileAccess.READ)

	var json: Dictionary = JSON.parse_string(file.get_as_text())
	var tower_array: Array = json["towers"]

	for tower: Dictionary in tower_array:
		var id: String = tower["id"]
		towers[id] = {
			"name": tower["name"],
			"price": tower["credit_price"],
			"scale": tower.get("scale", 1)
		}
		towersOwned[id] = false

func load_shop():
	var tower_ids: Array = towers.keys()
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

			name_label.text = towers[id].name
			price_label.text = str(towers[id].price) + "⋲"

			icon.texture = load(ICON_PATH + id + ".tres")
			icon.expand = true
			icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED

			var scale_value: float = float(towers[id].scale)
			icon.scale = Vector2(scale_value, scale_value)

			icon.pivot_offset = icon.size * 0.5

			slot.gui_input.connect(func(event):
				if event is InputEventMouseButton and event.pressed:
					on_shop_slot_pressed(slot)
			)

func on_shop_slot_pressed(slot):
	var id: String = slot.get_meta("tower_id")

	if towersOwned[id]:
		selected_tower = id
		updateTerminal("Selected " + towers[id].name)
		return

	var price: int = towers[id].price
	if Game.data.credits < price:
		updateTerminal("[color=red]Not enough balance[/color]")
		return

	Game.data.credits -= price
	towersOwned[id] = true
	selected_tower = id

	slot.get_node("PriceLabel").text = "Owned"
	updateTerminal("Purchased " + towers[id].name)

func connect_tower_slots():
	for slot in tower_container.get_children():
		slot.gui_input.connect(func(event):
			if event is InputEventMouseButton and event.pressed:
				on_tower_slot_pressed(slot)
		)

func on_tower_slot_pressed(slot):
	if towersEquipped.has(slot):
		var id: String = towersEquipped[slot]
		towersEquipped.erase(slot)

		slot.get_node("RichTextLabel").text = ""
		slot.get_node("TowerIcon").texture = null

		updateTerminal("Removed " + towers[id].name)
		return

	if selected_tower == "":
		updateTerminal("[color=yellow]No tower selected[/color]")
		return

	if not towersOwned[selected_tower]:
		updateTerminal("[color=red]Tower not owned[/color]")
		return

	towersEquipped[slot] = selected_tower
	slot.get_node("RichTextLabel").text = towers[selected_tower].name

	var icon: TextureRect = slot.get_node("TowerIcon")
	icon.texture = load(ICON_PATH + selected_tower + ".tres")
	icon.expand = true
	icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED

	var scale_value: float = float(towers[selected_tower].scale)
	icon.scale = Vector2(scale_value, scale_value)
	icon.pivot_offset = icon.size * 0.5

	updateTerminal("Equipped " + towers[selected_tower].name)

func updateTerminal(value):
	terminalBalance.text = "Balance: " + str(Game.data.credits) + "⋲"
	terminalText.text = value
