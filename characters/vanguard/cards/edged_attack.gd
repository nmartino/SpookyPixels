extends Card

func get_default_tooptip() -> String:
	return tooltip_text % special_stat_cost

func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value(special_stat_cost, Modifier.Type.DMG_DEALT)
	
	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
		
	return tooltip_text % modified_dmg

func apply_effects(targets: Array[Node], modifier: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifier.get_modified_value(special_stat_cost, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets, dmg_type)
