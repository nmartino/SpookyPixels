extends RuneData


func apply_effect(character: CharacterStats) -> void:
	print(cards_to_add)
	for card in get_cards_to_add():
		character.deck.add_card(card)

func remove_effect(character: CharacterStats) ->void:
	for card in cards_to_add:
		character.deck.remove_card(card)
		
