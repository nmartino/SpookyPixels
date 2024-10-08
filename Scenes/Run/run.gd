class_name Run

extends Node

const BATTLE_SCENE := preload("res://Scenes/Battle/battle.tscn")
const BATTLE_REWARD_SCENE := preload("res://Scenes/battle_reward/battle_reward.tscn")
const CAMPFIRE_SCENE := preload("res://Scenes/campfire/campfire.tscn")
const SHOP_SCENE := preload("res://Scenes/Shop/shop.tscn")
const TREASURE_SCENE = preload("res://Scenes/treasure/treasure.tscn")

@export var run_startup: RunStartup

@onready var map: Map = $Map
@onready var treasure_button: Button = %TreasureButton
@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var reward_button: Button = %RewardButton
@onready var campfire_button: Button = %CampfireButton
@onready var current_view: Node = $CurrentView
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView
@onready var gold_ui: GoldUI = %GoldUI

var stats: RunStats
var character: CharacterStats

func _ready() -> void:
	if not run_startup:
		return
		
	match run_startup.type:
		RunStartup.TYPE.NEW_RUN:
			character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.TYPE.CONTINUED_RUN:
			print("TODO: cargar partida guardada")

func _start_run() -> void:
	stats = RunStats.new()
	_setup_event_connection()
	_setup_top_bar()
	map.generate_new_map()
	map.unlock_floor(0)

func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count()>0:
		current_view.get_child(0).queue_free()
		
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	
	return new_view
	
func _setup_event_connection() -> void:
	Events.battle_won.connect(_on_battle_won)
	Events.battle_reward_exited.connect(_show_map)
	Events.campfire_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(_show_map)
	Events.treasure_room_exited.connect(_show_map)
	
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	map_button.pressed.connect(_show_map)
	reward_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))

func _setup_top_bar():
	gold_ui.run_stats = stats
	deck_button.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))

func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_change_view(BATTLE_SCENE)
		Room.Type.TREASURE:
			_change_view(TREASURE_SCENE)
		Room.Type.CAMPFIRE:
			_change_view(CAMPFIRE_SCENE)
		Room.Type.SHOP:
			_change_view(SHOP_SCENE)
		Room.Type.BOSS:
			_change_view(BATTLE_SCENE)

func _on_battle_won() -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character

	#this is temporary code, it will come from real battle encounter data
	# as a dependency
	reward_scene.add_gold_reward(77)
	reward_scene.add_card_reward()

func _show_map()->void:
	if current_view.get_child_count()> 0:
		current_view.get_child(0).queue_free()
	map.show_map()
	map.unlock_next_rooms()
