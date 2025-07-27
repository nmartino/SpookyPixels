extends Relic

@export var skills_required := 2
@export var damage := 2
var damageType := DamageEffect.Type.PHYSICAL
@export var sound: AudioStream

var relic_ui: RelicUI
var skills_this_turn: int

func initialize_relic(owner: RelicUI) -> void:
	relic_ui = owner
	Events.player_hand_drawn.connect(_reset)
	Events.map_exited.connect(_reset.unbind(1))
	Events.card_played.connect(_on_card_played)

	
func deactivate_relic(_owner: RelicUI) -> void:
	Events.player_hand_drawn.disconnect(_reset)
	Events.map_exited.disconnect(_reset)
	Events.card_played.disconnect(_on_card_played)

func _reset() ->void:
	skills_this_turn = 0

func _on_card_played(card: Card) -> void:
	if card.id == "warrior_axe_attack":
		skills_this_turn += 1
		
		
	elif  card.id == "warrior_slash_attack":
		skills_this_turn += 1
		
	else:
		return
	
	
	
	if skills_this_turn == skills_required:
		var enemies := relic_ui.get_tree().get_nodes_in_group("enemies")
		var damage_effect := DamageEffect.new()
		
		damage_effect.amount = damage
		damage_effect.receiver_modifier_type = Modifier.Type.NO_MODIFIER
		damage_effect.sound = sound
		damage_effect.execute(enemies, damageType)
		
		relic_ui.flash()
		skills_this_turn = 0
	
	
