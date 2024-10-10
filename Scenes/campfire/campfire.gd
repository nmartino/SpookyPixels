extends Control

@export var music: AudioStream

func _ready() -> void:
	MusicPlayer.play(music, true)

func _on_button_pressed() -> void:
	Events.campfire_exited.emit()
