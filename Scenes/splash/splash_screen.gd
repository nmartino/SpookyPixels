extends Control

const MAIN_MENU_PATH := "res://Scenes/UI/main_menu.tscn"

@onready var swoosh := preload("res://art/sounds/Retro Swooosh 07.wav")
@onready var ghost_appear := preload("res://art/sounds/Sin whoshProyecto GameDev Ghost Pixel.mp3")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var music: AudioStream

var animations: Array[StringName] = ["logos", "logoPixel", "fade_in_background"]
var skip_spamming_locked: bool = false

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	MusicPlayer.play(music, true)
	
	animation_player.stop()
	animation_player.clear_queue()
	for a in animations:
		animation_player.queue(a)

func _process(_delta: float) -> void:
	if Input.is_anything_pressed() && !skip_spamming_locked:
		skip_spamming_locked = true
		animation_player.seek(animation_player.current_animation_length - 0.01)
		get_tree().create_timer(0.5).timeout.connect(
			func(): skip_spamming_locked = false
		)
		SFXPlayer.stop()

func _play_swoosh() -> void:
	SFXPlayer.play(swoosh)
	
func _play_appear() -> void:
	SFXPlayer.play(ghost_appear)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in_background":
		get_tree().change_scene_to_file(MAIN_MENU_PATH)
