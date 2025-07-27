extends Control
@onready var animacion: AnimatedSprite2D = $animacion
@onready var inventory_slot: InventorySlot = $InventorySlot

func _on_inventory_slot_mouse_entered() -> void:
	animacion.play("hover")

func _on_inventory_slot_mouse_exited() -> void:
	animacion.play("default")
