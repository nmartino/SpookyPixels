class_name StatusView
extends Control

const STATUS_TOOLTIP = preload("res://Scenes/UI/status_tool_tip.tscn")

@onready var status_tool_tips: VBoxContainer = %StatusToolTips

func _ready() -> void:
	for tooltip: StatusToolTip in status_tool_tips.get_children():
		tooltip.queue_free()
	
	Events.status_tooltip_requested.connect(show_view)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible:
		hide_view()

func show_view(statuses: Array[Status])-> void:
	for status: Status in statuses:
		var new_status_tooltip := STATUS_TOOLTIP.instantiate() as StatusToolTip
		status_tool_tips.add_child(new_status_tooltip)
		new_status_tooltip.status = status
	show()

func hide_view() -> void:
	for tooltip: StatusToolTip in status_tool_tips.get_children():
		tooltip.queue_free()
	hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and visible:
		hide_view()


func _on_back_button_pressed() -> void:
	hide_view()
