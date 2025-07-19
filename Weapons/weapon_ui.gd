class_name WeaponUI
extends Area2D

#TODO no exportar?
@export var weapon: BaseWeapon
@onready var control: Control = $Control
@onready var label: Label = $Control/Label
@onready var texture_rect: TextureRect = $Control/TextureRect

var card_is_hovering: bool = false

func initialize(weapon_data: BaseWeapon, character: PlayerHandeler) -> void:
	#TODO ahhh, seguro hay que usar duplicate(). Mmmmmm
	weapon = weapon_data
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	texture_rect.texture = weapon.icon
	label.text = str(weapon.max_char_stat_value)
	weapon.start_of_combat(character)
	Events.weapon_combat_activation.connect(activate_weapon)

func activate_weapon(card: CardUI) -> void:
	pass


func _on_area_entered(_area: Area2D):
	card_is_hovering = true


func _on_area_exited(_area: Area2D):
	card_is_hovering = false
