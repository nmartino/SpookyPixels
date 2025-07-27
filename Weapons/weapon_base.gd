class_name BaseWeapon
extends Resource

enum WeaponStatType {DEFAULT, EDGE, MANA, ROGUE_STAT}

@export var name: StringName = "??????"
@export var starting_cards: Array[Card] = []
@export var max_attachment_slots: int = 0
@export var attachments: Array[WeaponAttachment] = []
@export var stat_type: WeaponStatType = WeaponStatType.DEFAULT
@export var max_char_stat_value: int = 0
@export var icon: Texture
@export var sound_fx: AudioStream = preload("res://art/enemy_hit_02.wav")
@export_multiline var tooltip: String

var character_stats: CharacterStats
var player_handler: PlayerHandeler
#callback de activación?

func start_of_run(c_h: CharacterStats) -> void:
	character_stats = c_h

func start_of_combat(p_h: PlayerHandeler) -> void:
	player_handler = p_h


func end_of_combat() -> void:
	pass

@warning_ignore("unused_parameter")
func _on_weapon_activated(card: CardUI) -> void:
	pass

func get_cards_to_add() -> Array[Card]:
	#este codigo no debería hacer falta para una copia, con usar deep alcanza, peeeero
		#var new_array: Array[Card] = []
	#for card: Card in cards:
		#new_array.append(card.duplicate())
	#return new_array
	return starting_cards.duplicate(true)

func get_attachments() -> Array[WeaponAttachment]:
	#idem a lo de starting cards
	return attachments.duplicate(true)

func add_attachment(new_att: WeaponAttachment) -> void:
	if attachments.size() >= max_attachment_slots:
		return
	var duplicated_att:= new_att.duplicate()
	#TODO ahhh, wazowzki, revisaste si deberías pasarle un true?
	attachments.append(duplicated_att)
	duplicated_att.apply_effect(character_stats)
	
	#TODO crear  

func remove_attachment(remove_att: WeaponAttachment) -> void:
	if attachments.is_empty():
		return
	for att in attachments:
		if att.name == remove_att.name:
			remove_att.remove_effect(character_stats)
			attachments.erase(att)
			break
