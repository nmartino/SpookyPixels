extends EnemyAction

const STRENGTH_STATUS = preload("res://statuses/strength.tres")

@export var stacks_per_action := 2

var hp_threshold := 25
var usages := 0

func is_perfomable() -> bool:
	var hp_under_threshol := enemy.stats.health <= hp_threshold
	
	if usages == 0 or (usages == 1 and hp_under_threshol):
		usages += 1
		return true
	
	return false

func perform_action()-> void:
	if not enemy or not target:
		return
	
	var stats_effect := StatusEffect.new()
	var strength := STRENGTH_STATUS.duplicate()
	strength.stacks = stacks_per_action
	stats_effect.status = strength
	stats_effect.execute([enemy],Effect.Type.NONE_FX)
	
	
	SFXPlayer.play(sound)
	
	Events.enemy_action_completed.emit(enemy)
