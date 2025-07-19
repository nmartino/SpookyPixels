class_name CharacterStats
extends Stats

@export_group("Visuals")
@export var character_name: String
@export_multiline var description: String
@export var portrait: Texture
@export var aura: Texture

@export_group("Gameplay Data")
@export var isDisable: bool
@export var starting_deck: CardPile
@export var draftable_cards: CardPile
@export var cards_per_turn: int
#@export var max_mana: int
#@export var starting_relic : Relic
@export var weapon: BaseWeapon
@export var special_stat_type : Card.SpecialStatsTypes = Card.SpecialStatsTypes.NONE
@export var special_stat_value : int = 0 : set = set_special_stat

#var mana: int : set = set_mana
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile


func set_special_stat(value: int) -> void:
	if value < 0:
		special_stat_value = 0
	else:
		special_stat_value = value
	stats_changed.emit()


func reset_special_stat_value() -> void:
	special_stat_value = weapon.max_char_stat_value


func take_damage(damage: int) -> void:
	var initial_health := health
	super.take_damage(damage)
	if initial_health > health:
		Events.player_hit.emit()


func can_play_card(card: Card) -> bool:
	return special_stat_value >= card.special_stat_cost


func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.reset_special_stat_value()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance
