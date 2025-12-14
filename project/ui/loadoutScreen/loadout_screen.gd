extends Control

const TOWERS := "res://common/data/towers.json"
const ICON := "res://common/assets/textures/sprites/towers/"

# var towers: Dictionary = {}
# var towersOwned: Dictionary = {}
# var towersEquipped: Dictionary = {}
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
	updateTerminal("[color=gray]Click on a tower to purchase or select. With one selected, click on a tower slot to equip.[/color]")

func load_towers():
	var file: FileAccess = FileAccess.open(TOWERS, FileAccess.READ)

	var json: Dictionary = JSON.parse_string(file.get_as_text())
	var tower_array: Array = json["towers"]

	for tower: Dictionary in tower_array:
		var id: String = tower["id"]
		Game.data.towers[id] = {
			"name": tower["name"],
			"price": tower["credit_price"],
			"scale": tower.get("scale", 1)
		}
		Game.data.towersOwned[id] = false

func load_shop():
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
			price_label.text = str(Game.data.towers[id].price) + "⋲"

			icon.texture = load(ICON + id + ".tres")
			icon.expand = true
			icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED

			var scale_value: float = float(Game.data.towers[id].scale)
			icon.scale = Vector2(scale_value, scale_value)

			icon.pivot_offset = icon.size * 0.5

			slot.gui_input.connect(func(event):
				if event is InputEventMouseButton and event.pressed:
					on_shop_slot_pressed(slot)
			)

func on_shop_slot_pressed(slot):
	var id: String = slot.get_meta("tower_id")

	if Game.data.towersOwned[id]:
		selected_tower = id
		updateTerminal("[color=gray]Selected " + Game.data.towers[id].name + "[/color]")
		return

	var price: int = Game.data.towers[id].price
	if Game.data.credits < price:
		updateTerminal("[color=red]Not enough balance[/color]")
		return

	Game.data.credits -= price
	Game.data.towersOwned[id] = true
	selected_tower = id

	slot.get_node("PriceLabel").text = "Owned"
	updateTerminal("[color=gray]Purchased " + Game.data.towers[id].name + "[/color]")

func connect_tower_slots():
	for slot in tower_container.get_children():
		slot.gui_input.connect(func(event):
			if event is InputEventMouseButton and event.pressed:
				on_tower_slot_pressed(slot)
		)

func on_tower_slot_pressed(slot):
	if Game.data.towersEquipped.has(slot):
		var id: String = Game.data.towersEquipped[slot]
		Game.data.towersEquipped.erase(slot)

		slot.get_node("RichTextLabel").text = ""
		slot.get_node("TowerIcon").texture = null

		updateTerminal("[color=gray]Removed " + Game.data.towers[id].name + "[/color]")
		return

	if selected_tower == "":
		updateTerminal("[color=yellow]No tower selected[/color]")
		return

	if not Game.data.towersOwned[selected_tower]:
		updateTerminal("[color=red]Tower not owned[/color]")
		return

	if Game.data.towersEquipped.values().has(selected_tower):
		updateTerminal(
			"[color=orange]" +
			Game.data.towers[selected_tower].name +
			" is already equipped[/color]"
		)
		return

	Game.data.towersEquipped[slot] = selected_tower
	slot.get_node("RichTextLabel").text = Game.data.towers[selected_tower].name

	var icon: TextureRect = slot.get_node("TowerIcon")
	icon.texture = load(ICON + selected_tower + ".tres")
	icon.expand = true
	icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED

	var scale_value: float = float(Game.data.towers[selected_tower].scale)
	icon.scale = Vector2(scale_value, scale_value)
	icon.pivot_offset = icon.size * 0.5

	updateTerminal("[color=gray]Equipped " + Game.data.towers[selected_tower].name + "[/color]")

func updateTerminal(value):
	terminalBalance.text = "Balance: [color=gold]" + str(Game.data.credits) + "⋲[/color]"
	terminalText.text = value
