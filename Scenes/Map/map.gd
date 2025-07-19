class_name Map
extends Node2D

const SCROLL_SPEED:= 15
const PAN_SPEED:= 1
const MAP_ROOM= preload("res://Scenes/Map/map_room.tscn")
const MAP_LINE= preload("res://Scenes/Map/map_line.tscn")

@onready var visuals: Node2D = %Visuals
@onready var lines: Node2D = %Lines
@onready var rooms: Node2D = %Rooms
@onready var camera_2d: Camera2D = $Camera2D
@onready var map_generator: MapGenerator = $MapGenerator
@onready var vertical_izquierda: Node2D = %verticalIzquierda
@onready var vertical_derecha: Node2D = %verticalDerecha
var paredes_verticales_izquierda: Array = ["Map_TowerWall_undead_01", "Map_TowerWall_undead_02",
"Map_TowerWall_undead_04", "Map_TowerWall_undead_06"]
var paredes_verticales_derecha: Array = ["Map_TowerWall_undead_01", "Map_TowerWall_undead_02",
"Map_TowerWall_undead_04", "Map_TowerWall_undead_05"]
var pared_vertical_sin_torre := "Map_TowerWall_undead_03"


var map_data: Array[Array]
var floors_climbed: int
var last_room: Room
var camera_edge_y: float
var camera_edge_x:= 640

var touchPoints: Dictionary = {}

func _ready() -> void:
	camera_edge_y = MapGenerator.Y_DIST * (MapGenerator.FLOORS - 1) - 60
	for sprite in vertical_derecha.get_children():
		if sprite.get_index() == 1 or sprite.get_index() == 3 or sprite.get_index() == 5:
			sprite.play(pared_vertical_sin_torre)	
		else:
			sprite.play(paredes_verticales_derecha.pick_random())
	for sprite in vertical_izquierda.get_children():
		if sprite.get_index() == 1 or sprite.get_index() == 3 or sprite.get_index() == 5:
			sprite.play(pared_vertical_sin_torre)
		else:
			sprite.play(paredes_verticales_izquierda.pick_random())


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
		
	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y -= SCROLL_SPEED
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y += SCROLL_SPEED
	
	if event is InputEventScreenDrag:
		_handle_drag(event)
		
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)
	camera_2d.position.x = clamp(0, camera_edge_x, 0)

func _handle_drag(event: InputEventScreenDrag):
	touchPoints[event.index] = event.position
	
	if touchPoints.size() == 1:
		camera_2d.position -= event.relative * PAN_SPEED
		


func generate_new_map() -> void:
	floors_climbed = 0
	map_data = map_generator.generate_map()
	create_map()

func load_map(map:Array[Array], floor_completed: int, last_room_climbed: Room) -> void:
	floors_climbed = floor_completed
	map_data = map
	last_room = last_room_climbed
	create_map()
	
	if floors_climbed > 0:
		unlock_next_rooms()
	else:
		unlock_floor()

func create_map() ->void:
	for current_floor: Array in map_data:
		for room: Room in current_floor:
			if room.next_rooms.size() > 0:
				_spawn_room(room)
	#boss room no tiene nex room asi que hay que spawnearlo
	var middle:= floori(MapGenerator.MAP_WIDTH *0.5)
	_spawn_room(map_data[MapGenerator.FLOORS-1][middle])
	
	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH -1)
	visuals.position.x = (get_viewport_rect().size.x - map_width_pixels)/2
	visuals.position.y = get_viewport_rect().size.y /2

func unlock_floor(which_floor: int = floors_climbed) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.row == which_floor:
			map_room.available = true

func unlock_next_rooms() -> void:
	for map_room: MapRoom in rooms.get_children():
		if last_room.next_rooms.has(map_room.room):
			map_room.available = true
		

func show_map() ->void:
	show()
	camera_2d.enabled = true

func hide_map() ->void:
	hide()
	camera_2d.enabled = false

func _spawn_room(room: Room) -> void:
	var new_map_room := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(new_map_room)
	new_map_room.room = room
	new_map_room.clicked.connect(_on_map_room_clicked)
	new_map_room.selected.connect(_on_map_room_selected)
	_connect_lines(room)
	
	if room.selected and room.row < floors_climbed:
		new_map_room.show_selected()
		
func _connect_lines(room: Room) -> void:
	if room.next_rooms.is_empty():
		return
	for next: Room in room.next_rooms:
		var new_map_line := MAP_LINE.instantiate() as Line2D
		new_map_line.add_point(room.position)
		new_map_line.add_point(next.position)
		lines.add_child(new_map_line)

		
func _on_map_room_selected(room: Room) -> void:
	last_room = room
	floors_climbed += 1
	Events.map_exited.emit(room)

func _on_map_room_clicked(room: Room) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.row == room.row:
			map_room.available = false
