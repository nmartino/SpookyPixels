class_name BattleUI
extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var hand: Hand = $Hand as Hand
@onready var edge_ui: EdgeUI =$EdgeUI as EdgeUI
@onready var end_turn_button: TextureButton = %EndTurnButton
@onready var draw_pile_button: CardPileOpener = %DrawPileButton
@onready var discard_pile_button: CardPileOpener = %DiscardPileButton
@onready var draw_pile_view: CardPileView = %DrawPileView
@onready var discard_pile_view: CardPileView = %DiscardPileView
@onready var button_animation: AnimationPlayer = %ButtonAnimation



func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	draw_pile_button.pressed.connect(draw_pile_view.show_current_view.bind("Draw Pile", true))
	discard_pile_button.pressed.connect(discard_pile_view.show_current_view.bind("Discard Pile"))
	
func initialize_card_pile_ui() -> void:
	draw_pile_button.card_pile = char_stats.draw_pile
	draw_pile_view.card_pile = char_stats.draw_pile
	discard_pile_button.card_pile = char_stats.discard
	discard_pile_view.card_pile = char_stats.discard

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	edge_ui.char_stats = char_stats
	hand.char_stats = char_stats


func _on_player_hand_drawn()-> void:
	end_turn_button.disabled = false

func _on_end_turn_button_pressed()-> void:
	end_turn_button.disabled = true
	button_animation.play("rotate")
	await button_animation.animation_finished
	Events.player_turn_ended.emit()
