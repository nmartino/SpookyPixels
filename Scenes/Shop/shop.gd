class_name Shop
extends Control

const SHOP_CARD = preload("res://Scenes/Shop/shop_card.tscn")

var  dialogs := ["Dying for\nsome business,\nliterally.",
"No\nrefunds—hauntings\nincluded!",
"Gold or your soul,\nplease.",
"Spooky deals,\nguaranteed or\ncursed.",
"I'll ghost you\n10% off."]

var bought_dialogs :=["Your doom is sealed!", "Pleasure doing\ndark business.",
"Thanks for your soul!", "Your fate is set!"]

var fondo_animation_array := ["fondo_a","fondo_b","fondo_c"]

@export var char_stats: CharacterStats
@export var run_stats: RunStats
@export var music: AudioStream

@onready var cards: HBoxContainer = %Cards
@onready var card_tool_tip_pop_up: CardTooltipPopup = %CardToolTipPopUp
@onready var shop_keeper_animation: AnimationPlayer = %ShopKeeperAnimation
@onready var blink_timer: Timer = %BlinkTimer
@onready var shop_keeper_dialogs: Label = %ShopKeeperDialogs
@onready var dialog_timer: Timer = %DialogTimer
@onready var modifier_handler: ModifierHandler = $ModifierHandler
@onready var fondo_animation: AnimationPlayer = %FondoAnimation
@onready var fondo_animation_timer: Timer = %FondoAnimationTimer



func _ready() -> void:
	MusicPlayer.play(music, true)
	for shop_card: ShopCard in cards.get_children():
		shop_card.queue_free()
	
	Events.shop_card_bought.connect(_on_shop_card_bought)
	
	_blink_timer_setup()
	blink_timer.timeout.connect(_on_blink_timer_timeout)
	_dialog_timer_setup()
	dialog_timer.timeout.connect(_on_dialog_timer_timeout)
	_fondo_timer_setup()
	fondo_animation_timer.timeout.connect(_on_fondo_animation_timer_timout)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and card_tool_tip_pop_up.visible:
		card_tool_tip_pop_up.hide_tooltip()

func populate_shop() -> void:
	_generate_shop_cards()

func _blink_timer_setup()-> void:
	blink_timer.wait_time = randf_range(1.0,5.0)
	blink_timer.start()

func _on_blink_timer_timeout() -> void:
	shop_keeper_animation.play("blink")
	_blink_timer_setup()

func _fondo_timer_setup()-> void:
	fondo_animation_timer.wait_time = randf_range(10.0,15.0)
	fondo_animation_timer.start()

func _on_fondo_animation_timer_timout() ->void:
	var fondo_animation_chosed = fondo_animation_array.pick_random()
	fondo_animation.play(fondo_animation_chosed)

func _dialog_timer_setup(dialog_wait_time : float = randf_range(4.0,8.0)) -> void:
	if dialog_timer:
		dialog_timer.stop()
	dialog_timer.wait_time = dialog_wait_time 
	dialog_timer.start()

func _on_dialog_timer_timeout() -> void:
	shop_keeper_dialogs.text = dialogs.pick_random()
	_dialog_timer_setup()

func _generate_shop_cards() -> void:
	var shop_card_array: Array[Card] = []
	var available_cards :Array[Card] = char_stats.draftable_cards.duplicate_cards()
	RNG.array_shuffle(available_cards)
	shop_card_array = available_cards.slice(0,3)
	
	for card: Card in shop_card_array:
		var new_shop_card:= SHOP_CARD.instantiate() as ShopCard
		cards.add_child(new_shop_card)
		new_shop_card.card = card
		new_shop_card.current_card_ui.tooltip_requested.connect(card_tool_tip_pop_up.show_tooltip)
		new_shop_card.gold_cost = _get_updated_shop_cost(new_shop_card.gold_cost)
		new_shop_card.update(run_stats)


func _update_items() -> void:
	for shop_card: ShopCard in cards.get_children():
		shop_card.update(run_stats)


func _update_item_cost() -> void:
	for shop_card: ShopCard in cards.get_children():
		shop_card.gold_cost = _get_updated_shop_cost(shop_card.gold_cost)
		shop_card.update(run_stats)


func _get_updated_shop_cost(original_cost: int) -> int:
	return modifier_handler.get_modified_value(original_cost, Modifier.Type.SHOP_COST)

func _on_back_button_pressed() -> void:
	Events.shop_exited.emit()
	
func _on_shop_card_bought(card:Card, gold_cost: int) -> void:
	char_stats.deck.add_card(card)
	run_stats.gold -= gold_cost
	shop_keeper_dialogs.text = bought_dialogs.pick_random()
	_update_items()
	_dialog_timer_setup(2.5)
