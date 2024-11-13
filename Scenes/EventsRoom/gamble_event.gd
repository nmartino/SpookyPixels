class_name GambleEvent
extends EventRoom

@onready var fifty_button: EventRoomButton = %FiftyButton
@onready var thirty_button: EventRoomButton = %ThirtyButton
@onready var skip_button: EventRoomButton = %SkipButton
@onready var background: Sprite2D = %Background

var backgrounds := [
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo1.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo2.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo3.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo4.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo5.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo6.png")
]

func setup() -> void:
	skip_button.visible = run_stats.gold < 50
	fifty_button.disabled = run_stats.gold < 50
	thirty_button.disabled = run_stats.gold < 50
	
	fifty_button.event_button_callback = bet_50
	thirty_button.event_button_callback = bet_30
	
	background.texture = RNG.array_pick_random(backgrounds)
	
func bet_30() -> void:
	thirty_button.disabled = true
	run_stats.gold -= 50
	
	if RNG.instance.randf() < 0.3:
		run_stats.gold += 200

func bet_50() -> void:
	fifty_button.disabled = true
	run_stats.gold -= 50
	
	if RNG.instance.randf() < 0.5:
		run_stats.gold += 100
