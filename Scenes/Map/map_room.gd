class_name MapRoom
extends Area2D

signal selected(room:Room)
signal clicked (room: Room)


const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.MONSTER: [preload("res://art/1bit/pruebas mapa/doble_espada_mapa.png"), Vector2.ONE],
	Room.Type.TREASURE: [preload("res://art/1bit/pruebas mapa/treasure_2_prueba.png"), Vector2.ONE],
	Room.Type.CAMPFIRE: [preload("res://art/1bit/pruebas mapa/campfire_2_prueba.png"), Vector2.ONE],
	Room.Type.SHOP: [preload("res://art/1bit/pruebas mapa/shop_mapa.png"), Vector2.ONE],
	Room.Type.BOSS: [preload("res://art/1bit/pruebas mapa/map-icon-boss-x24.png"), Vector2.ONE],
	Room.Type.EVENT: [preload("res://art/1bit/pruebas mapa/event2-2.png"),Vector2.ONE],
	Room.Type.ELITE: [preload("res://art/1bit/pruebas mapa/map-icon-elites-x24.png"), Vector2.ONE]
}

@export var sound: AudioStream

@onready var line_2d: Line2D = $Visuals/Line2D
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var finished: Sprite2D = %Finished
@onready var entrance: AnimatedSprite2D = %Entrance
@onready var visuals: Node2D = $Visuals
@onready var entrance_collision: CollisionShape2D = $entranceCollision

var available := false : set = set_available
var room: Room : set = set_room

func set_available(new_value: bool) -> void:
	available = new_value
	
	if available:
		visuals.show()
		animation_player.play("highlight")
	elif not room.selected:
		animation_player.play("RESET")
		
func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]
	#visuals.hide()
	if room.position.y == 0:
		entrance_collision.disabled = false
		entrance.show()
	else:
		entrance.hide()

func show_selected()-> void:
	finished.modulate = Color.WHITE

@warning_ignore("unused_parameter")
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return
	
	room.selected = true
	clicked.emit(room)
	if entrance.is_visible_in_tree():
		entrance.play("open")
		SFXPlayer.play(sound)
		await entrance.animation_finished
	animation_player.play("selected")
	
#llama cuando la animacion selected termina
func _on_map_room_selected() -> void:
	selected.emit(room)
	
