class_name BattleOverPanel
extends Panel

enum Type {WIN, LOSE}
const MUSIC_MAIN_MENU = preload("res://art/sounds/The dungeon remains.mp3")
const MAIN_MENU_PATH = "res://Scenes/UI/main_menu.tscn"

@onready var label: Label = %Label
@onready var continue_button :Button = %ContinueButton
@onready var main_menu_button: Button = %MainMenuButton


func _ready() -> void:
	continue_button.pressed.connect(func(): Events.battle_won.emit())
	main_menu_button.pressed.connect(_go_to_main_menu)
	Events.battle_over_screen_requested.connect(show_screen)

func _go_to_main_menu()-> void:
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
	MusicPlayer.play(MUSIC_MAIN_MENU, true)

func show_screen(text: String, type: Type) -> void:
	label.text = text
	continue_button.visible = type == Type.WIN
	main_menu_button.visible = type == Type.LOSE
	show()
	get_tree().paused = true
