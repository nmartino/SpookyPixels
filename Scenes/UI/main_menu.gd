extends Control

const CHAR_SELECTOR_SCENE := preload("res://Scenes/UI/character_selector.tscn")

@export var music: AudioStream

@onready var transition: AnimationPlayer = $transition
@onready var continue_button: Button = %Continue


func _ready() -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)

func _on_continue_pressed() -> void:
	print("continue run")


func _on_new_run_pressed() -> void:
	transition.play("fade_out")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_transition_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)
