extends Card

var base_block := 10
var exhaust_amount := 2

func get_default_tooptip() -> String:
	return tooltip_text % base_block

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text % base_block

func apply_effects(targets: Array[Node], _modifier: ModifierHandler)-> void:
	var block_effect := BlockEffect.new()
	block_effect.amount = base_block
	block_effect.sound = sound
	block_effect.execute(targets, dmg_type)
	
	var exhaust_random_effect := ExhaustRandomEffect.new()
	exhaust_random_effect.amount = exhaust_amount
	exhaust_random_effect.execute(targets, dmg_type)
