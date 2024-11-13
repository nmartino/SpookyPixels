class_name TheEternalFeastEvent
extends EventRoom

@onready var duplicate_last_card_button : EventRoomButton = %DuplicateLastCard 
@onready var plus_max_hp_button: EventRoomButton = %PlusMaxHPButton
@onready var background: Sprite2D = %Background

var backgrounds := [
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo1.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo2.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo3.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo4.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo5.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo6.png")
]

func _ready() -> void:
	duplicate_last_card_button.event_button_callback = duplicate_last_card
	plus_max_hp_button.event_button_callback = plus_max_hp
	

func duplicate_last_card() -> void:
	character_stats.deck.add_card(character_stats.deck.cards[-1].duplicate())

func plus_max_hp() -> void:
	character_stats.max_health += 5

func setup() -> void:
	background.texture = RNG.array_pick_random(backgrounds)
