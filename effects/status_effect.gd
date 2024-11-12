class_name StatusEffect

extends Effect
const BUFF_FX = preload("res://Scenes/CardFxs/buff_fx.tscn")

var status: Status


func execute(targets: Array[Node], type: Type) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.status_handler.add_status(status)
			var buff = BUFF_FX.instantiate()
			target.add_child(buff)
			buff.buff.play("Buff")
			buff.buff.animation_finished.connect(
				func():
					buff.queue_free()
			)
			SFXPlayer.play(sound)
