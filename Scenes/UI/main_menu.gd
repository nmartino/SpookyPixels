extends Control

const CHAR_SELECTOR_SCENE := preload("res://Scenes/UI/character_selector.tscn")
const RUN_SCENE = preload("res://Scenes/Run/run.tscn")

@export var music: AudioStream
@export var run_startup: RunStartup

@onready var transition: AnimationPlayer = $transition
@onready var continue_button: Button = %Continue


func _ready() -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	continue_button.disabled = SaveGame.load_data() == null

func _on_continue_pressed() -> void:
	run_startup.type = RunStartup.TYPE.CONTINUED_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_new_run_pressed() -> void:
	transition.play("fade_out")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_transition_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)
