class_name CardVisuals
extends Control

@export var card: Card : set = set_card

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var rarity: TextureRect = $Rarity
@onready var power_label: Label = $Power

func _ready():
	check_value()

func check_value():
	if power_label.text == "0" or power_label.text == "":
		power_label.visible = false
	else:
		power_label.visible = true

func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready

	card = value
	cost.text = str(card.cost)
	power_label.text = str(card.power)
	icon.texture = card.icon
	rarity.modulate = Card.RARITY_COLORS[card.rarity]
