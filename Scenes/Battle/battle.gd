class_name Battle
extends Node2D

var backgrounds := [
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo1.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo2.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo3.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo4.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo5.png"),
	preload("res://art/1bit/orcoArt/Sprite Fondos testeo6.png")
]

@export var battle_stats: BattleStats
@export var char_stats: CharacterStats
@export var music: AudioStream
@export var battle_won: AudioStream
@export var relics: RelicHandler

@onready var background: Sprite2D = %Background
@onready var battle_ui: BattleUI = $BattleUI 
@onready var player_handeler: PlayerHandeler = $PlayerHandeler 
@onready var enemy_handeler: EnemyHandeler = $EnemyHandeler 
@onready var player: Player = $Player 



func _ready() -> void:

	background.texture = RNG.array_pick_random(backgrounds)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	enemy_handeler.child_order_changed.connect(_on_enemies_child_order_changed)	
	Events.player_turn_ended.connect(player_handeler.end_turn)
	Events.player_hand_discarded.connect(enemy_handeler.start_turn)	
	Events.player_died.connect(_on_player_died)
	
	
	
func start_battle()-> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	battle_ui.char_stats = char_stats
	player.stats = char_stats
	player_handeler.relics = relics
	enemy_handeler.setup_enemies(battle_stats)
	enemy_handeler.reset_enemy_actions()
	relics.relics_activated.connect(_on_relics_activated)
	relics.activate_relic_by_type(Relic.Type.START_OF_COMBAT)

func _on_enemies_child_order_changed()->void:
	if enemy_handeler.get_child_count() == 0 and is_instance_valid(relics):
		SFXPlayer.play(battle_won,true)
		relics.activate_relic_by_type(Relic.Type.END_OF_COMBAT)

func _on_player_died()-> void:
	Events.battle_over_screen_requested.emit("You Lose!!", BattleOverPanel.Type.LOSE)
	SaveGame.delete_data()

func _on_enemy_turn_ended()-> void:
	player_handeler.start_turn()
	enemy_handeler.reset_enemy_actions()

func _get_char_stats() -> CharacterStats:
	return char_stats

func _on_relics_activated(type: Relic.Type) -> void:
	match type:
		Relic.Type.START_OF_COMBAT:
			player_handeler.start_battle(char_stats)
			battle_ui.initialize_card_pile_ui()
		Relic.Type.END_OF_COMBAT:
			Events.battle_over_screen_requested.emit("Perfection!!", BattleOverPanel.Type.WIN)
	
