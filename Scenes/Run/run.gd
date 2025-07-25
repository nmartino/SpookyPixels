class_name Run

extends Node

const BATTLE_SCENE := preload("res://Scenes/Battle/battle.tscn")
const BATTLE_REWARD_SCENE := preload("res://Scenes/battle_reward/battle_reward.tscn")
const CAMPFIRE_SCENE := preload("res://Scenes/campfire/campfire.tscn")
const SHOP_SCENE := preload("res://Scenes/Shop/shop.tscn")
const TREASURE_SCENE = preload("res://Scenes/treasure/treasure.tscn")
const WIN_SCREEN_SCENE := preload("res://Scenes/win_screen/win_screen.tscn")
const INVENTORY_SCENE := preload("res://Scenes/UI/weapon_screen.tscn")
const MAIN_MENU_PATH := "res://Scenes/UI/main_menu.tscn"

const MOCKED_RUNE = preload("res://Runas/mocked_rune.tres")

@export var music: AudioStream

@export var run_startup: RunStartup

@onready var map: Map = $Map
@onready var current_view: Node = $CurrentView
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView
@onready var gold_ui: GoldUI = %GoldUI
#@onready var health_ui: HealthUI = %HealthUI
@onready var relic_handler: RelicHandler = %RelicHandler
@onready var relic_tool_tip: RelicTooltip = %RelicToolTip
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var weapon_inventory: WeaponInventory = %WeaponScreen
@onready var avatar_ui: AvatarUI = %AvatarUi

var stats: RunStats
var character: CharacterStats
var save_data: SaveGame

func _ready() -> void:
	if not run_startup:
		return
	
	pause_menu.save_and_quit.connect(
		func():
			get_tree().change_scene_to_file(MAIN_MENU_PATH)
	)
	
	match run_startup.type:
		RunStartup.TYPE.NEW_RUN:
			character = run_startup.picked_character.create_instance()
			
			_start_run()
		RunStartup.TYPE.CONTINUED_RUN:
			_load_run()


func _start_run() -> void:
	stats = RunStats.new()
	
	_setup_event_connection()
	_setup_top_bar()
	
	map.generate_new_map()
	map.unlock_floor(0)
	
	
	save_data = SaveGame.new()
	_save_run(true)
	
	
func _save_run(was_on_map: bool) -> void:
	save_data.rng_seed = RNG.instance.seed
	save_data.rng_state = RNG.instance.state
	save_data.run_stats = stats
	save_data.char_stats = character
	save_data.current_deck = character.deck
	save_data.current_health = character.health
	save_data.relics = relic_handler.get_all_relics()
	save_data.last_room = map.last_room
	save_data.map_data = map.map_data.duplicate()
	save_data.floors_climbed = map.floors_climbed
	save_data.was_on_map = was_on_map
	save_data.save_data()

func _load_run() ->void:
	save_data = SaveGame.load_data()
	assert(save_data, "no se pudo cargar la run anterior")
	
	RNG.set_from_save_data(save_data.rng_seed, save_data.rng_state)
	stats = save_data.run_stats
	character = save_data.char_stats
	character.deck = save_data.current_deck
	character.health = save_data.current_health
	relic_handler.add_relics(save_data.relics)
	_setup_top_bar()
	_setup_event_connection()
	
	
	map.load_map(save_data.map_data, save_data.floors_climbed, save_data.last_room)
	if save_data.last_room and not save_data.was_on_map:
		_on_map_exited(save_data.last_room)
	
	
	
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
	Events.inventory_exited.connect(_show_map)
	Events.treasure_room_exited.connect(_on_treasue_room_exited)
	Events.event_room_exited.connect(_show_map)

func _setup_top_bar():
	character.stats_changed.connect(avatar_ui.update_stats.bind(character))
	#character.stats_changed.connect(avatar_ui._on_stats_updated.bind(character))
	avatar_ui.update_stats(character)
	gold_ui.run_stats = stats
	#relic_handler.add_relic(character.starting_relic)
	Events.relic_tooltip_requested.connect(relic_tool_tip.show_tooltip)
	deck_button.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))
	character.weapon.start_of_combat(character)
	avatar_ui.avatar_button.pressed.connect(_on_inventory_open)
	

func _show_regular_battle_rewards() -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character

	reward_scene.add_gold_reward(map.last_room.battle_stats.roll_gold_reward())
	reward_scene.add_card_reward()

func _on_battle_room_entered(room: Room) ->void:
	avatar_ui.avatar_button.disabled = true
	var battle_scene: Battle = _change_view(BATTLE_SCENE) as Battle
	battle_scene.char_stats = character
	battle_scene.battle_stats = room.battle_stats
	battle_scene.relics = relic_handler
	battle_scene.start_battle()

func _on_treasue_room_entered() -> void:
	var treasure_scene := _change_view(TREASURE_SCENE) as Treasure
	treasure_scene.relic_handler = relic_handler
	treasure_scene.char_stats = character
	treasure_scene.generate_relic()

func _on_treasue_room_exited(relic: Relic) -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character
	reward_scene.relic_handler = relic_handler
	
	reward_scene.add_relic_reward(relic)

func _on_campfire_room_entered() -> void:
	var campfire:= _change_view(CAMPFIRE_SCENE) as CampFire
	campfire.char_stats = character
	campfire.player_sprite.texture = character.campfire_art

func _on_shop_entered() -> void:
	var shop := _change_view(SHOP_SCENE) as Shop
	shop.char_stats = character
	shop.run_stats = stats
	shop.relic_handler = relic_handler
	Events.shop_entered.emit(shop)
	shop.populate_shop()
	
func _on_event_room_entered(room: Room) -> void:
	var event_room := _change_view(room.event_scene) as EventRoom
	event_room.character_stats = character
	event_room.run_stats = stats
	event_room.setup()

func _on_map_exited(room: Room) -> void:
	_save_run(false)
	match room.type:
		Room.Type.MONSTER:
			_on_battle_room_entered(room)
		Room.Type.TREASURE:
			_on_treasue_room_entered()
		Room.Type.CAMPFIRE:
			_on_campfire_room_entered()
		Room.Type.SHOP:
			_on_shop_entered()
		Room.Type.BOSS:
			_on_battle_room_entered(room)
		Room.Type.EVENT:
			_on_event_room_entered(room)

func _on_battle_won() -> void:
	avatar_ui.avatar_button.disabled = false
	if map.floors_climbed == MapGenerator.FLOORS:
		var win_screen := _change_view(WIN_SCREEN_SCENE) as WinScreen
		win_screen.character = character
		SaveGame.delete_data()
	else:
		_show_regular_battle_rewards()


func _show_map()->void:
	MusicPlayer.play(music, true)		
	if current_view.get_child_count()> 0:
		current_view.get_child(0).queue_free()
	map.show_map()
	map.unlock_next_rooms()
	_save_run(true)
	
func _on_inventory_open() ->void:
	weapon_inventory.show_weapon_inventory(character.weapon)


func _on_button_runa_pressed() -> void:
	weapon_inventory.register_rune(MOCKED_RUNE)
