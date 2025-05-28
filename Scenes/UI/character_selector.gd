extends Control


const RUN_SCENE := preload("res://Scenes/Run/run.tscn")
const ASSASSIN_STATS := preload("res://characters/Assassin/Assassin.tres")
const WARRIOR_STATS := preload("res://characters/warrior/warrior.tres")
const MAGE_STATS := preload("res://characters/Mage/mage.tres")

@export var run_startup: RunStartup

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var mage_portrait: TextureRect = $MagePortrait
@onready var archer_portrait: TextureRect = $ArcherPortrait
@onready var vanguard_portrait: TextureRect = $VanguardPortrait
@onready var mage_portrait_sin_shader: TextureRect = $MagePortrait_SinShader
@onready var archer_portrait_2_sin_shader: TextureRect = $ArcherPortrait2_SinShader
@onready var vanguard_portrait_2_sin_shader: TextureRect = $VanguardPortrait2_SinShader

@onready var transition: AnimationPlayer = $transition

var current_character: CharacterStats : set = set_current_character

func _ready() -> void:
	transition.play("fade_in")
	set_current_character(WARRIOR_STATS)
	
func set_current_character(new_character: CharacterStats) -> void:
	current_character = new_character
	title.text = current_character.character_name
	description.text = current_character.description


func _on_start_button_pressed() -> void:
	run_startup.type = RunStartup.TYPE.NEW_RUN
	run_startup.picked_character = current_character
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_warrior_button_pressed() -> void:
	vanguard_portrait.show()
	mage_portrait.hide()
	archer_portrait.hide()
	vanguard_portrait_2_sin_shader.hide()
	mage_portrait_sin_shader.show()
	archer_portrait_2_sin_shader.show()
	current_character = WARRIOR_STATS
	


func _on_mage_button_pressed() -> void:
	vanguard_portrait.hide()
	mage_portrait.show()
	mage_portrait_sin_shader.hide()
	archer_portrait.hide()
	vanguard_portrait_2_sin_shader.show()
	archer_portrait_2_sin_shader.show()
	current_character = MAGE_STATS


func _on_assasin_button_pressed() -> void:
	vanguard_portrait.hide()
	mage_portrait.hide()
	archer_portrait.show()
	archer_portrait_2_sin_shader.hide()
	vanguard_portrait_2_sin_shader.show()
	mage_portrait_sin_shader.show()
	current_character = ASSASSIN_STATS
