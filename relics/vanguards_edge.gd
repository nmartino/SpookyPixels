extends Relic

@export var max_edge: int

var current_edge: int


func initialize_relic(_owner: RelicUI) -> void:
	current_edge = max_edge
	Events.relic_combat_manual_activation.connect(_on_relic_activated)
	#Events.card_played.connect(_on_card_played)
	Events.relic_edge_decrease.connect(_on_edge_decrease)

func activate_relic(_owner: RelicUI) -> void:
	pass
	

# este metodo se deberia implementar para relics de base-event
# que conecta al eventBus para asegurarse que son desconectados
# cuando una relic es removida
func deactivate_relic(_owner: RelicUI) -> void:
	pass
	

func _on_relic_activated(card: Card) -> void:
	pass


func _on_card_played(card: Card) ->   void:
	pass


func _on_edge_decrease(amount: int) -> void:
	current_edge -= amount
	print("Edge reduction by %s, current edge is: %s" % [str(amount), str(current_edge)])


func get_edge() -> int:
	return current_edge



#________________________________________________________
# meta-name: Relic
# meta-description: Creat una relic nueva que puede ser usada por el player.

#extends Relic
#
#var member_var := 0
#
#func initialize_relic(_owner: RelicUI) -> void:
	#print("this happens once when we gain a new relic")
#
#func activate_relic(_owner: RelicUI) -> void:
	#print("this happens at specific times based on the Relic.Type property")
	#
#func deactivate_relic(_owner: RelicUI) -> void:
	#print("this gets called when a RelicUI is exiting the SceneTree i.e getting deleted")
	#print("Event-based Relics should disconnect from the EventBus here.")
	#
#
## we can provide unique tooltips per relic if we want to
#func get_tooltip() -> String:
	#return tooltip
