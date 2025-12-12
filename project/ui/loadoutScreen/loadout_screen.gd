extends Control

var towers := {}
var towersOwned := {}
var selected_tower = ""

@onready var terminalText: RichTextLabel = $Terminal/RichTextLabel
@onready var terminalBalance: RichTextLabel = $Terminal/Balance

func _ready() -> void:
	updateBalance(Game.data.credits)

func _process(delta: float) -> void:
	pass

func updateMessage(text):
	terminalText.text = text

func updateBalance(value):
	terminalBalance.text = "Balance: " + str(value) + "⋲"
