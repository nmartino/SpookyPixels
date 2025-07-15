extends RuneData

@export var edge:int = 0 
var modificadores: Dictionary = {"hp":0,"edge":0,"cards":[]}
#todo mandar en el diccionario 

func apply_effect(character: CharacterStats) -> void:
	character.max_health = character.max_health + edge
	character.stats_changed.emit()
	#modificadores["edge"] = edge
	#return modificadores

func remove_effect(character: CharacterStats) ->void:
	character.max_health = character.max_health - edge
	character.stats_changed.emit()
