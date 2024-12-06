class_name TheEternalFeastEvent
extends EventRoom

@onready var duplicate_last_card_button : EventRoomButton = %DuplicateLastCard 
@onready var plus_max_hp_button: EventRoomButton = %PlusMaxHPButton
@onready var torch_left: AnimatedSprite2D = $torchLeft
@onready var torch_middle: AnimatedSprite2D = $torchMiddle
@onready var torch_right: AnimatedSprite2D = $torchRight
@onready var background: AnimatedSprite2D = %Background

var backgrounds := [
	"background1",
	"background2",
	"background3",
	"background4",
	"background5",
	"background6"
]

func _ready() -> void:
	duplicate_last_card_button.event_button_callback = duplicate_last_card
	plus_max_hp_button.event_button_callback = plus_max_hp
	
	

func duplicate_last_card() -> void:
	character_stats.deck.add_card(character_stats.deck.cards[-1].duplicate())

func plus_max_hp() -> void:
	character_stats.max_health += 5

func setup() -> void:
	background.animation = RNG.array_pick_random(backgrounds)
	match background.animation:
		"background1":
			torch_left.global_position.x = 64
			torch_middle.global_position.x = 184
			torch_right.hide()
		"background2":
			torch_left.global_position.x = 64
			torch_middle.global_position.x = 184
			torch_right.hide()
		"background3":
			torch_left.global_position.x = 14
			torch_middle.global_position.x = 184
			torch_right.hide()
		"background4":
			torch_left.global_position.x = 14
			torch_middle.global_position.x = 184
			torch_right.hide()
		"background5":
			torch_left.global_position.x = 47
			torch_middle.global_position.x = 129
			torch_right.global_position.x = 211
		"background6":
			torch_left.global_position.x = 47
			torch_middle.global_position.x = 129
			torch_right.global_position.x = 211
