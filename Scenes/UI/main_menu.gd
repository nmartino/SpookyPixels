extends Control

const CHAR_SELECTOR_SCENE := preload("res://Scenes/UI/character_selector.tscn")
const RUN_SCENE := preload("res://Scenes/Run/run.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var configuration_panel: Panel = $ConfigurationPanel
@onready var conf_menu_container: MarginContainer = $ConfigurationPanel/ConfMenuContainer

@export var run_startup: RunStartup
@onready var continue_button: Button = %Continue

var skip_spamming_locked: bool = false
var its_config_displayed : bool = false


func _ready() -> void:
	get_tree().paused = false
	continue_button.disabled = SaveGame.load_data() == null
	animation_player.play("AnimacionMainMenu")
	await animation_player.animation_finished
	animation_player.play("aparicionTituloMenu")
	
func _process(_delta: float) -> void:
	if Input.is_anything_pressed() && !skip_spamming_locked:
		skip_spamming_locked = true
		animation_player.seek(animation_player.current_animation_length - 0.01)
		get_tree().create_timer(0.5).timeout.connect(
			func(): skip_spamming_locked = false
		)

func _on_continue_pressed() -> void:
	run_startup.type = RunStartup.TYPE.CONTINUED_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)


func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_config_pressed() -> void:
	if not its_config_displayed:
		configuration_panel.show()
		animation_player.play("open_conf_menu")
		await animation_player.animation_finished
		conf_menu_container.show()
		its_config_displayed = true


func _on_hide_pressed() -> void:
	if its_config_displayed:
		conf_menu_container.hide()
		animation_player.play("close_conf_menu")
		await animation_player.animation_finished
		configuration_panel.hide()
		its_config_displayed = false
