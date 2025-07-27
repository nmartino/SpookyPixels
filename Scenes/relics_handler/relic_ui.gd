class_name RelicUI
extends Control

@export var relic: Relic : set = set_relic

@onready var icon: TextureRect = $Icon
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func set_relic(new_relic: Relic) -> void:
	if not is_node_ready():
		await ready
	
	relic = new_relic
	icon.texture = relic.icon

func flash() -> void:
	SFXPlayer.play(relic.sound_fx)
	animation_player.play("Flash")

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		Events.relic_tooltip_requested.emit(relic)
