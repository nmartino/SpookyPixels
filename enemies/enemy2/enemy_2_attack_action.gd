extends EnemyAction

@export var damage := 3

func perform_action()-> void:
	if not enemy or not target:
		return
	
	var tween:= create_tween().set_trans(Tween.TRANS_QUINT)
	var start:= enemy.global_position
	var end:= target.global_position + Vector2.RIGHT * 96
	var damage_effect := DamageEffect.new()
	var target_array: Array[Node] = [target]
	damage_effect.amount = damage
	damage_effect.sound = sound
		
	tween.tween_property(enemy,"global_position", end, 0.4)
	tween.tween_callback(damage_effect.execute.bind(target_array,Effect.Type.PHYSICAL))
	tween.tween_interval(0.35)
	tween.tween_callback(damage_effect.execute.bind(target_array,Effect.Type.PHYSICAL))
	tween.tween_interval(0.25)
	tween.tween_property(enemy,"global_position", start, 0.4)
	
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)

func update_intent_text() -> void:
	var player := target as Player
	if not player:
		return 
	
	var modified_dmg := player.modifier_handler.get_modified_value(damage, Modifier.Type.DMG_DEALT)
	intent.current_text = intent.base_text % modified_dmg
