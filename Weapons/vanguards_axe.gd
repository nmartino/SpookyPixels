extends BaseWeapon

func start_of_combat(p_h: PlayerHandeler):#_owner: RelicUI) -> void:
	player_handler = p_h
	
	if not Events.weapon_combat_activation.is_connected(_on_weapon_activated):
		Events.weapon_combat_activation.connect(_on_weapon_activated)
	


func end_of_combat() -> void:
	Events.weapon_end_of_combat_activation.emit()


func _on_weapon_activated(card_ui: CardUI) -> void:
	#Así descartan cartas desde PlayerHandler
	#tween.tween_callback(character.discard.add_card.bind(card_ui.card))
	#tween.tween_callback(hand.discard_card.bind(card_ui))
	player_handler.character.discard.add_card(card_ui.card)
	player_handler.hand.discard_card(card_ui)
	player_handler.character.reset_special_stat_value()
