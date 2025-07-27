class_name WeaponAttachment
extends Resource

enum ActivationTypes {START_OF_TURN, START_OF_COMBAT, END_OF_TURN, END_OF_COMBAT, EVENT_BASED}

@export var name: StringName
@export var cards_to_add: Array[Card]
@export var activation_type: ActivationTypes
@export var icon: Texture
@export var sound_fx: AudioStream = preload("res://art/enemy_hit_02.wav")
@export_multiline var tooltip: String


func can_add_cards() -> bool:
	return not cards_to_add.is_empty()

func get_cards_to_add() -> Array[Card]:
	return cards_to_add.duplicate(true)

@warning_ignore("unused_parameter")	
func apply_effect(character: CharacterStats) -> void:
	pass

@warning_ignore("unused_parameter")
func remove_effect(character: CharacterStats) ->void:
	pass 
