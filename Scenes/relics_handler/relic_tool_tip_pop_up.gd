class_name RelicTooltip
extends Control

@onready var relic_icon: TextureRect = %RelicIcon
@onready var relic_tool_tip: RichTextLabel = %RelicToolTip



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible:
		hide()

func show_tooltip(relic: Relic)-> void:
	relic_icon.texture = relic.icon
	relic_tool_tip.text = relic.get_tooltip()
	show()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		hide()
