extends RuneData

@export var edge:int = 0 

func apply_effect(character: CharacterStats) -> void:
	character.max_health = character.max_health + edge
	character.stats_changed.emit()

func remove_effect(character: CharacterStats) ->void:
	character.max_health = character.max_health - edge
	character.stats_changed.emit()
