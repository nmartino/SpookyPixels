extends Card

var base_damage := 6
var extra_damage_after_use := 4

func get_default_tooptip() -> String:
	return tooltip_text % [base_damage, extra_damage_after_use]

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := _player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	
	if _enemy_modifiers:
		modified_dmg = _enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
		
	return tooltip_text % [modified_dmg, extra_damage_after_use]

func apply_effects(targets: Array[Node], _modifier: ModifierHandler)-> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = _modifier.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets, dmg_type)
	
	base_damage += extra_damage_after_use
