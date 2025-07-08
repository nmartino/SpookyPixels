class_name WeaponInventory
extends Control

var InventorySize = 12
@onready var rune_slots: GridContainer = %RuneSlots
@onready var back_button: Button = $BackButton

@export var itemsLoad = [
	"res://Runas/mocked_gem.tres",
	"res://Runas/mocked_rune.tres"
	]

func _ready() -> void:
	for i in itemsLoad.size():
		var item := InventoryRune.new()
		item.init(load(itemsLoad[i]))
		rune_slots.get_child(i).add_child(item)
	back_button.pressed.connect(hide)


func show_weapon_inventory() ->void:
	show()
