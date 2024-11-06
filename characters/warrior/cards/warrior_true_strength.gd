extends Card

const TRUE_STRENGTH_FORM_STATUS = preload("res://statuses/true_strength_form.tres")
@export var buff : PackedScene

func apply_effects(targets: Array[Node], _modifier: ModifierHandler)-> void:
	var status_effect := StatusEffect.new()
	var true_strength := TRUE_STRENGTH_FORM_STATUS.duplicate()
	status_effect.status = true_strength
	status_effect.execute(targets, dmg_type)
