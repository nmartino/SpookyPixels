class_name Battle
extends Node2D

var backgrounds := [
	"background1",
	"background2",
	"background3",
	"background4",
	"background5",
	"background6"
]

@export var battle_stats: BattleStats
@export var char_stats: CharacterStats
@export var music: AudioStream
@export var discard_sound: AudioStream
@export var battle_won: AudioStream


@onready var edge_ui: EdgeUI = %EdgeUI
@onready var background: AnimatedSprite2D = %Background
@onready var battle_ui: BattleUI = $BattleUI 
@onready var player_handeler: PlayerHandeler = $PlayerHandeler 
@onready var enemy_handeler: EnemyHandeler = $EnemyHandeler 
@onready var player: Player = $Player
@onready var weapon_ui: WeaponUI = $WeaponUI
@onready var tool_tip: ToolTip = $BattleUI/ToolTipLayer/ToolTip


func _ready() -> void:
	background.animation = RNG.array_pick_random(backgrounds)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	enemy_handeler.child_order_changed.connect(_on_enemies_child_order_changed)	
	Events.player_turn_ended.connect(player_handeler.end_turn)
	Events.player_hand_discarded.connect(enemy_handeler.start_turn)	
	Events.player_died.connect(_on_player_died)
	Events.card_aim_started.connect(_on_aim_started)
	Events.card_aim_ended.connect(_on_aim_ended)


func start_battle()-> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	char_stats.set_special_stat(10)
	battle_ui.char_stats = char_stats
	player.stats = char_stats
	enemy_handeler.setup_enemies(battle_stats)
	enemy_handeler.reset_enemy_actions()
	player_handeler.start_battle(char_stats)
	battle_ui.initialize_card_pile_ui()
	weapon_ui.initialize(player.stats.weapon, player_handeler)

func _on_enemies_child_order_changed() -> void:
	if enemy_handeler.get_child_count() == 0:
		MusicPlayer.play(battle_won,false)
		Events.tooltip_hide_requested.emit()
		Events.battle_over_screen_requested.emit(
			"Perfection!!", BattleOverPanel.Type.WIN
		)

func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("You Lose!!", BattleOverPanel.Type.LOSE)
	SaveGame.delete_data()

func _on_enemy_turn_ended() -> void:
	player_handeler.start_turn()
	enemy_handeler.reset_enemy_actions()

func _get_char_stats() -> CharacterStats:
	return char_stats


func _on_aim_started(card: CardUI)->void:
	SFXPlayer.play(discard_sound)
	edge_ui.discard_sprite.show()
	edge_ui.mana_label.hide()
	edge_ui.name_label.hide()
	edge_ui.discard.show()

func _on_aim_ended(card: CardUI)->void:
	edge_ui.discard_sprite.hide()
	edge_ui.mana_label.show()
	edge_ui.name_label.show()
	edge_ui.discard.hide()
	


func _on_flip_pressed() -> void:
	Events.flip_cards.emit()
