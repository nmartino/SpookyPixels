extends Node2D

@export var char_stats: CharacterStats
@export var music: AudioStream

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handeler: PlayerHandeler = $PlayerHandeler as PlayerHandeler
@onready var enemy_handeler: EnemyHandeler = $EnemyHandeler as EnemyHandeler
@onready var player: Player = $Player as Player

func _ready() -> void:
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	enemy_handeler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.player_turn_ended.connect(player_handeler.end_turn)
	Events.player_hand_discarded.connect(enemy_handeler.start_turn)	
	Events.player_died.connect(_on_player_died)
	
	start_battle(new_stats)
	
	
func start_battle(stats: CharacterStats)-> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	enemy_handeler.reset_enemy_actions()
	player_handeler.start_battle(stats)

func _on_enemies_child_order_changed()->void:
	if enemy_handeler.get_child_count() == 0:
		Events.battle_over_screen_requested.emit("Perfection!!", BattleOverPanel.Type.WIN)

func _on_player_died()-> void:
	Events.battle_over_screen_requested.emit("Game Over!!", BattleOverPanel.Type.LOSE)

func _on_enemy_turn_ended()-> void:
	player_handeler.start_turn()
	enemy_handeler.reset_enemy_actions()
	
