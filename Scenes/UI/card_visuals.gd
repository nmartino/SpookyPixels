class_name CardVisuals
extends Control

@export var card: Card : set = set_card

@onready var panel: TextureRect = $AttackPanel
@onready var defense_panel: TextureRect = $DefensePanel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var rarity: TextureRect = $Rarity
@onready var card_name: Label = $CardName
@onready var card_description: RichTextLabel = $CardDescription

func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	if value == null:
		return
		
	
	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon
	rarity.modulate = Card.RARITY_COLORS[card.rarity]
	card_name.text = value.id
	card_description.text = value.get_default_tooptip()
