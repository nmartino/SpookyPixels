extends CardState

var played: bool


func enter() -> void:
	played = false
	if card_ui.targets.is_empty():
		return
	
	#debería tener tamaño 1 el array pero qué decirte
	for t in card_ui.targets:
		if t.is_in_group("weaponUI"):
			Events.weapon_combat_activation.emit(card_ui)
			return
	
	Events.tooltip_hide_requested.emit()
	played = true
	card_ui.play()

func post_enter() -> void:
	transition_requested.emit(self, CardState.State.BASE)
