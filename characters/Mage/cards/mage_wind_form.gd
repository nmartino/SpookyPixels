extends Card

const MAGE_WIND_FORM = preload("res://statuses/wind_form.tres")
@export var buff : PackedScene

func apply_effects(targets: Array[Node], _modifier: ModifierHandler)-> void:
	var status_effect := StatusEffect.new()
	var wind_form := MAGE_WIND_FORM.duplicate()
	status_effect.status = wind_form
	status_effect.execute(targets, dmg_type)
