class_name InventorySlot
extends PanelContainer

@export var raresa: RuneData.Raresa

	
func init(r: RuneData.Raresa, cms: Vector2) ->void:
	raresa = r
	custom_minimum_size = cms

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is InventoryRune:
		if raresa == RuneData.Raresa.Common:
			if get_child_count() == 0:
				return true
			else:
				if raresa == data.get_parent().raresa:
					return true
			return get_child(0).data.raresa == data.data.raresa
		else:
			return data.data.raresa == raresa
	return false

func _drop_data(_at_position: Vector2, data: Variant):
	if get_child_count() > 0:
		var runa := get_child(0)
		if runa == data:
			return
		runa.reparent(data.get_parent())
	data.reparent(self)
