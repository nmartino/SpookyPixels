# meta-name: Event Room
# meta-description: Crear una custom room para un evento
class_name MyAwesomeEvent
extends EventRoom

@onready var example_button: EventRoomButton = %ExampleButton

func _ready() -> void:
	# you can use EventRoomButton to create simple button behaviour.
	# These buttons automatically emit Events.event_room_exited when pressed.
	# However, you can pass an optional Callable that executes BEFORE that happens.
	example_button.event_button_callback = add_gold
	
	# If yout EventRoom does not need buttons
	# Make sure to emit this signal when you are done with everything
	# Events.event_room_exited.emit()
	
func add_gold() -> void:
	run_stats.gold += 50

#if you want to do something once after injecting the dependencies
#do it here
func setup() -> void:
	pass
