class_name Card
extends Resource

enum Rarity {COMMON, UNCOMMON, RARE}
enum Type {ATTACK, SKILL, POWER}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}
#TODO este type o el de las cartas tiene que quedar, pero solo uno
enum SpecialStatsTypes {NONE, EDGE, MANA, ROGUE_STAT}

const RARITY_COLORS := {
	Card.Rarity.COMMON: Color.WHITE,
	Card.Rarity.UNCOMMON: Color.CYAN,
	Card.Rarity.RARE: Color.MAGENTA,
}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var rarity: Rarity
@export var exhausts: bool = false
@export var dmg_type: Effect.Type
var cost: int = 10 #TODO sacar esto, o dejar de hablar de "tipo especial" para las stats
@export var special_stat_type : SpecialStatsTypes = SpecialStatsTypes.NONE
@export var special_stat_cost:= 0
#: Dictionary = {SpecialStatsTypes.NONE: 0}#[SpecialStatsTypes: Int]

@export_group("Card Visuals")
@export var icon: Texture
@export var arte: Texture
@export_multiline var tooltip_text: String
@export var sound: AudioStream



func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY


func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
		
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []


func play(targets: Array[Node], char_stats: CharacterStats, modifiers: ModifierHandler) -> void:
	Events.card_played.emit(self)
	char_stats.special_stat_value -= special_stat_cost
	
	if is_single_targeted():
		apply_effects(targets, modifiers)
	else:
		apply_effects(_get_targets(targets), modifiers)

@warning_ignore("unused_parameter")
func apply_effects(_targets: Array[Node], modifier: ModifierHandler) -> void:
	pass

func get_default_tooptip() -> String:
	return tooltip_text

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text
