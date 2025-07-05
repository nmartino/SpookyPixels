extends BaseWeapon

func start_of_combat():#_owner: RelicUI) -> void:
	Events.weapon_combat_activation.connect(_on_weapon_activated)
	
	#Events.card_played.connect(_on_card_played)
	#Events.relic_edge_decrease.connect(_on_edge_decrease)

func end_of_combat() -> void:
	Events.weapon_end_of_combat_activation.emit()
	pass


func _on_weapon_activated(card: CardUI) -> void:
	
	pass

# este metodo se deberia implementar para relics de base-event
# que conecta al eventBus para asegurarse que son desconectados
# cuando una relic es removida
#func deactivate_relic(_owner: RelicUI) -> void:
	#pass
