# meta-name: EnemyAction
# meta-description: An action which can be performed by an enemy during its turn.

extends EnemyAction

func perform_action()-> void:
	if not enemy or not target:
		return
	
	var tween:= create_tween().set_trans(Tween.TRANS_QUINT)
	var start:= enemy.global_position
	var end:= target.global_position + Vector2.RIGHT * 32
	
	SFXPlayer.play(sound)
	
	Events.enemy_action_completed.emit(enemy)
	
#si el intent es dinamico se puede hacer override del base text
# por ejemplo, por ataque, el modificador DMG_TAKEN del player modifica el resultado del numero de danio
func update_intent_text() -> void:
	var player := target as Player
	if not player:
		return 
	
	var modified_dmg := player.modifier_handler.get_modified_value(6, Modifier.Type.DMG_TAKEN)
	intent.current_text = intent.base_text % modified_dmg
