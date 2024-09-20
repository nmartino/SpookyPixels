extends Control

const ASSASSIN_STATS := preload("res://characters/Assassin/Assassin.tres")
const WARRIOR_STATS := preload("res://characters/warrior/warrior.tres")
const MAGE_STATS := preload("res://characters/Mage/mage.tres")

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var character_portrait: TextureRect = $CharacterPortrait
@onready var transition: AnimationPlayer = $transition

var current_character: CharacterStats : set = set_current_character

func _ready() -> void:
	transition.play("fade_in")
	set_current_character(WARRIOR_STATS)
	
func set_current_character(new_character: CharacterStats) -> void:
	current_character = new_character
	title.text = current_character.character_name
	description.text = current_character.description
	character_portrait.texture = current_character.portrait

func _on_start_button_pressed() -> void:
	print("start new run with %s" % current_character.character_name)


func _on_warrior_button_pressed() -> void:
	current_character = WARRIOR_STATS


func _on_mage_button_pressed() -> void:
	current_character = MAGE_STATS


func _on_assasin_button_pressed() -> void:
	current_character = ASSASSIN_STATS