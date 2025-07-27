extends Card

@export var reduction : int = 4

func get_default_tooptip() -> String:
	return tooltip_text % reduction


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler     ) -> String:
	return tooltip_text % reduction


func apply_effects(_targets: Array[Node], _modifier: ModifierHandler)-> void:
	Events.relic_edge_decrease.emit(reduction)
