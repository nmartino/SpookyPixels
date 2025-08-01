class_name WinScreen
extends Control

const MAIN_MENU_PATH = "res://Scenes/UI/main_menu.tscn"
const MESSAGE:= "You’ve slain the odds!!\nrest in peace, champ!"

@export var character: CharacterStats: set = set_character
@export var music : AudioStream

@onready var character_portrait: TextureRect = %CharacterPortrait
@onready var message: Label = %Message
@onready var character_aura: Sprite2D = $CharacterAura
@onready var animation_aura: AnimationPlayer = $CharacterAura/AnimationAura

func _ready() -> void:
	MusicPlayer.play(music,true)
	animation_aura.play("rotar")

func set_character(new_character: CharacterStats) -> void:
	character = new_character
	character_portrait.texture = character.portrait
	character_aura.texture = character.aura

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
