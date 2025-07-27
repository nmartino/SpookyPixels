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
@onready var animation: AnimationPlayer = $Animation
var isAttack :bool = true

func _ready() -> void:
	Events.flip_cards.connect(_on_flip_cards)

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


func _hide_labels() ->void:
	cost.hide()
	card_name.hide()
	card_description.hide()
	icon.hide()

func _show_labels() ->void:
	cost.show()
	card_name.show()
	card_description.show()
	icon.show()

func _on_flip_cards()->void:
	if isAttack:
		isAttack = false
		animation.play("flip_to_defenze")
	else:
		isAttack = true
		animation.play("flip_to_attack")
