# meta-=name: Card Logic
# meta-description: What happens when a card is played.
extends Card

@export var optiona_sound: AudioStream

func get_default_tooptip() -> String:
	return tooltip_text

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text

func apply_effects(targets: Array[Node], _modifier: ModifierHandler)-> void:
	print("My awesome card has been played!")
	print("Targets: %s" % targets)
