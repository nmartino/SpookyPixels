extends Control


const RUN_SCENE := preload("res://Scenes/Run/run.tscn")
const ASSASSIN_STATS := preload("res://characters/Assassin/Assassin.tres")
const WARRIOR_STATS := preload("res://characters/warrior/warrior.tres")
const MAGE_STATS := preload("res://characters/Mage/mage.tres")
const MAIN_MENU_PATH := "res://Scenes/UI/main_menu.tscn"

@export var run_startup: RunStartup
@onready var carousel_container: CarouselContainer = %CarouselContainer
@onready var character: Sprite2D = $Character
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var start_button: Button = $StartButton
@onready var right: TextureButton = $Carousel/Right
@onready var left: TextureButton = $Carousel/Left
@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var warrior_icon: Button = $CharacterButtons/WarriorIcon
@onready var mage_icon: Button = $CharacterButtons/MageIcon
@onready var assassin_icon: Button = $CharacterButtons/AssassinIcon
@onready var character_aura: Sprite2D = $CharacterAura
@onready var animation_aura: AnimationPlayer = $CharacterAura/AnimationAura
@onready var hp_label: Label = %HPLabel
@onready var cards_per_turn_label: Label = %CardsPerTurnLabel
@onready var weapon_label: Label = %WeaponLabel

var current_character: CharacterStats : set = set_current_character

func _ready() -> void:
	set_current_character(WARRIOR_STATS)
	#warrior_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#mage_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#assassin_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	animation_aura.play("rotar")
	
func set_current_character(new_character: CharacterStats) -> void:
	current_character = new_character
	match new_character:
		WARRIOR_STATS:
			warrior_icon.button_pressed = true
			mage_icon.button_pressed = false
			assassin_icon.button_pressed = false
		MAGE_STATS:
			warrior_icon.button_pressed = false
			mage_icon.button_pressed = true
			assassin_icon.button_pressed = false
		ASSASSIN_STATS:
			warrior_icon.button_pressed = false
			mage_icon.button_pressed = false
			assassin_icon.button_pressed = true
	title.text = current_character.character_name
	description.text = current_character.description
	hp_label.text = "HP: "+str(current_character.max_health)
	cards_per_turn_label.text = "Cards Per Turn: "+str(current_character.cards_per_turn)
	weapon_label.text = "Weapon: "+current_character.starting_relic.relic_name

func _on_start_button_pressed() -> void:
	run_startup.type = RunStartup.TYPE.NEW_RUN
	run_startup.picked_character = current_character
	get_tree().change_scene_to_packed(RUN_SCENE)

func _on_left_pressed() -> void:
	if carousel_container.selected_index == 0:
		carousel_container.selected_index = carousel_container.position_offset_node.get_child_count()-1
		print(carousel_container.selected_index)
	else:
		carousel_container._left()
	update_character()

func _on_right_pressed() -> void:
	if carousel_container.selected_index == carousel_container.position_offset_node.get_child_count()-1:
		carousel_container.selected_index = 0
		print(carousel_container.selected_index)
	else:
		carousel_container._right()
	update_character()
	
func update_character() ->void:
	match carousel_container.position_offset_node.get_child(carousel_container.selected_index).name:
		"WarriorButton":
				playAnimations(WARRIOR_STATS)				
		"MageButton":
				playAnimations(MAGE_STATS)
		"AssasinButton":
				playAnimations(ASSASSIN_STATS)
				
	
func playAnimations(character : CharacterStats) ->void:
	animation_aura.play("auraSale")
	animation_player.play("characterSale")
	current_character = character
	start_button.disabled = current_character.isDisable
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "characterSale":
		match current_character:
			WARRIOR_STATS:
				character.texture = WARRIOR_STATS.portrait
				character_aura.texture = WARRIOR_STATS.aura
			MAGE_STATS:
				character.texture = MAGE_STATS.portrait
				character_aura.texture = MAGE_STATS.aura
			ASSASSIN_STATS:
				character.texture = ASSASSIN_STATS.portrait
				character_aura.texture = ASSASSIN_STATS.aura
		animation_player.play("characterEntra")
		animation_aura.play("auraEntra")
		await animation_aura.animation_finished
		animation_aura.play("rotar")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_PATH)


func _on_warrior_icon_pressed() -> void:
	playAnimations(WARRIOR_STATS)


func _on_mage_icon_pressed() -> void:
	playAnimations(MAGE_STATS)


func _on_assassin_icon_pressed() -> void:
	playAnimations(ASSASSIN_STATS)
