extends Card
var base_damage := 3
const EXPOSED_STATUS = preload("res://statuses/exposed.tres")
var exposed_duration := 3

func get_default_tooptip() -> String:
	return tooltip_text % base_damage

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	
	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
		
	return tooltip_text % modified_dmg

func apply_effects(targets: Array[Node], _modifier: ModifierHandler)-> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = _modifier.get_modified_value(base_damage, Modifier.Type.NO_MODIFIER)
	damage_effect.receiver_modifier_type = Modifier.Type.NO_MODIFIER
	damage_effect.sound = sound
	damage_effect.execute(targets, dmg_type)
	
	if targets.is_empty():
		return
	
	var status_effect: StatusEffect
	
	for target: Node in targets:
		status_effect = StatusEffect.new()
		var exposed = EXPOSED_STATUS.duplicate() as Status
		exposed.duration = exposed_duration
		status_effect.status = exposed
		status_effect.execute([target], dmg_type)
	
	
