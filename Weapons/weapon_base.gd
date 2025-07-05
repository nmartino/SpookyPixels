class_name BaseWeapon
extends Resource

enum WeaponStatType {DEFAULT, EDGE, MANA, ROGUE_STAT}

@export var name: StringName
@export var starting_cards: Array[Card] = []
@export var max_attachment_slots: int = 0
@export var attachments: Array[WeaponAttachment] = []
@export var stat_type: WeaponStatType = WeaponStatType.DEFAULT
@export var max_stat_value: int = 1
@export var current_stat_value: int = 0 : set = set_stat_current_value
@export var icon: Texture
@export var sound_fx: AudioStream = preload("res://art/enemy_hit_02.wav")
@export_multiline var tooltip: String


#callback de activación?
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
	#TODO ahhh, wazowzki, revisaste si deberías pasarle un true?
	attachments.append(new_att.duplicate())

func remove_attachment(remove_att: WeaponAttachment) -> void:
	if attachments.is_empty():
		return
	for attachment in attachments:
		pass

func set_stat_current_value(val: int) -> void:
	current_stat_value = clampi(val, 0, max_stat_value)
