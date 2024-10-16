class_name CampFire
extends Control


@export var music: AudioStream
@export var char_stats: CharacterStats

@onready var player_sprite: Sprite2D = %PlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	MusicPlayer.play(music, true)


func _on_rest_button_pressed() -> void:
	char_stats.heal(ceili(char_stats.max_health * 0.3))
	animation_player.play("fade_out")
	

#se usa la funcion dsd animation player al final de fade_out
func _on_fade_out_finished() -> void:
	Events.campfire_exited.emit()
	
