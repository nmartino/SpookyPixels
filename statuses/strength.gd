class_name StrengthStatus
extends Status

func get_tooltip() -> String:
	return tooltip % stacks

func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node)-> void:
	assert(target.get("modifier_handler"), "no modifiers on %s" % target)
	
	var dmg_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmg_dealt_modifier, "no dmg dealt modifier on %s"% target)
	
	var strength_modifier_value := dmg_dealt_modifier.get_value("strength")
	
	if not strength_modifier_value:
		strength_modifier_value = ModifierValue.create_new_modifier("strength", ModifierValue.Type.FLAT)
	
	strength_modifier_value.flat_value = stacks
	dmg_dealt_modifier.add_new_value(strength_modifier_value)
