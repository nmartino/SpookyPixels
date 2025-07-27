class_name BlockEffect
extends Effect

var amount := 0


@warning_ignore("unused_parameter")
func execute(targets: Array[Node], type: Type) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.stats.block += amount
			SFXPlayer.play(sound)
