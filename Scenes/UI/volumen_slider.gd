extends HSlider

@export_enum("Master", "SFX", "Music") var bus_name: String = "Master"

@onready var _bus_index: int = AudioServer.get_bus_index(bus_name)

func _ready() -> void:
	value = AudioServer.get_bus_volume_linear(_bus_index)
	value_changed.connect(_on_value_changed)

func _on_value_changed(volumen: float) -> void:
	AudioServer.set_bus_volume_linear(_bus_index, volumen)
