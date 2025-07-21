class_name Treasure
extends Control

@export var char_stats: CharacterStats
@export var music : AudioStream

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var treasure_chest: TextureRect = $TreasureChest

func _ready() -> void:
	MusicPlayer.play(music, true)
	treasure_chest.gui_input.connect(_on_treasure_chest_gui_input)

# Called from the animationPlayer, at the
# end of the 'open' animation.
func _on_treasure_opened() -> void:
	Events.treasure_room_exited.emit()

func _on_treasure_chest_gui_input(event: InputEvent) -> void:
	if animation_player.current_animation == "open":
		return
	if event.is_action_pressed("left_mouse"):
		animation_player.play("open")
