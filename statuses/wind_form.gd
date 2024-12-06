class_name WindFormStatus
extends Status

var already_initialized = false
	

func apply_status(owner: Node) -> void:
	if already_initialized:
		return
	var player := owner.get_tree().get_first_node_in_group("player") as Player
	Events.player_hand_drawn.connect(_add_mana.bind(player))
	already_initialized = true

func _add_mana(owner: Player) ->void:
	var player:= owner
	if not player.stats.mana == player.stats.max_mana+2:
		player.stats.mana += 2
