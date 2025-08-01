class_name CardTooltipPopup
extends Control

const CARD_MENU_UI_SCENE := preload("res://Scenes/UI/card_menu_ui.tscn")

@export var background_color: Color = Color("000000dc")

@onready var background: ColorRect = $Background
@onready var tooltip_card: CenterContainer = %TooltipCard
@onready var tooltip_cardvbox: VBoxContainer = %TooltipCardvbox
@onready var card_description_atack: RichTextLabel = %CardDescriptionAtack
@onready var card_description_def: RichTextLabel = %CardDescriptionDef


func _ready() -> void:
	for card_menu_ui: CardMenuUI in tooltip_cardvbox.get_children():
		card_menu_ui.queue_free()
	
	background.color = background_color

	


func show_tooltip(card: Card) -> void:
	if not card:
		return
	var new_card_attack := CARD_MENU_UI_SCENE.instantiate() as CardMenuUI
	tooltip_cardvbox.add_child(new_card_attack)
	new_card_attack.card = card
	new_card_attack.tooltip_requested.connect(hide_tooltip.unbind(1))
	var new_card_def := CARD_MENU_UI_SCENE.instantiate() as CardMenuUI
	tooltip_cardvbox.add_child(new_card_def)
	new_card_def.card = card
	set_def_card(new_card_def, card)
	card_description_atack.text = card.get_default_tooptip()
	card_description_def.text = card.tooltip_text_def
	show()

func hide_tooltip() -> void:
	if not visible:
		return
	
	for card: CardMenuUI in tooltip_cardvbox.get_children():
		card.queue_free()
	
	hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		hide_tooltip()

func set_def_card(cardUI: CardMenuUI, card: Card)->void:
	cardUI.tooltip_requested.connect(hide_tooltip.unbind(1))
	cardUI.visuals.defense_panel.scale.x = 1.0
	cardUI.visuals.attack_panel.scale.x = 0.0
	cardUI.visuals.cost.position = Vector2(61,4)
	cardUI.visuals.card_name.position = Vector2(5,5)
	cardUI.visuals.card_name.text = card.id_def
	cardUI.visuals.card_description.text = card.tooltip_text_def
	cardUI.visuals.icon.texture = card.defenza
