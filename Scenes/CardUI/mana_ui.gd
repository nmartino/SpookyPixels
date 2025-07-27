class_name EdgeUI
extends NinePatchRect

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var mana_label : Label = $ManaLabel
@onready var edge_bar: ProgressBar = $EdgeBar
@onready var name_label: Label = $Name_label
@onready var discard: Label = $Discard
@onready var discard_sprite: Sprite2D = $DiscardSprite



func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	
	if not char_stats.stats_changed.is_connected(_on_stats_changed):
		char_stats.stats_changed.connect(_on_stats_changed)
	
	if not is_node_ready():
		await ready
	
	_on_stats_changed()

func _on_stats_changed() -> void:
	mana_label.text = "%s/%s" % [char_stats.special_stat_value, char_stats.weapon.max_char_stat_value]
	edge_bar.max_value = char_stats.weapon.max_char_stat_value
	edge_bar.value = char_stats.special_stat_value
	#mana_label.text = "%s/%s" % [char_stats.mana, char_stats.max_mana]
