extends Control

const MAIN_MENU_PATH := "res://Scenes/UI/main_menu.tscn"

@onready var swoosh := preload("res://art/sounds/Retro Swooosh 07.wav")
@onready var ghost_appear := preload("res://art/sounds/Retro Electronic Burst 05.wav")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var music: AudioStream

func _ready() -> void:
	MusicPlayer.play(music, true)
	
	
	

func _play_swoosh() -> void:
	SFXPlayer.play(swoosh)
	

func _play_appear() -> void:
	SFXPlayer.play(ghost_appear)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "logos":
		animation_player.play("logoPixel")
	
	if anim_name == "logoPixel":
		get_tree().change_scene_to_file(MAIN_MENU_PATH)
