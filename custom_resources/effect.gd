class_name Effect
extends Resource

var sound: AudioStream
enum Type {FIRE, PHYSICAL, ICE, ARROW, NONE_FX, LIGHTING}

func execute(_targets: Array[Node], _type: Type)-> void:
	pass
