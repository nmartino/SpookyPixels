class_name BattleOverPanel
extends Panel

enum Type {WIN, LOSE}

const MAIN_MENU_PATH = "res://Scenes/UI/main_menu.tscn"

@onready var label: Label = %Label
@onready var continue_button :Button = %ContinueButton
@onready var restart_button: Button = %RestartButton


func _ready() -> void:
	continue_button.pressed.connect(func(): Events.battle_won.emit())
	restart_button.pressed.connect(get_tree().change_scene_to_file.bind(MAIN_MENU_PATH))
	Events.battle_over_screen_requested.connect(show_screen)


func show_screen(text: String, type: Type) -> void:
	label.text = text
	continue_button.visible = type == Type.WIN
	restart_button.visible = type == Type.LOSE
	show()
	get_tree().paused = true
