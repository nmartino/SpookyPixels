class_name WeaponUI
extends Area2D

#TODO no exportar?
@export var weapon: BaseWeapon
@onready var control: Control = $Control
@onready var label: Label = $Control/Label
@onready var texture_rect: TextureRect = $Control/TextureRect


func initialize(weapon_data: BaseWeapon) -> void:
	#TODO ahhh, seguro hay que usar duplicate(). Mmmmmm
	weapon = weapon_data
	texture_rect.texture = weapon.icon
	label.text = str(weapon.max_char_stat_value)

func activate_weapon(card: CardUI) -> void:
	pass
