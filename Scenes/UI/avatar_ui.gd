class_name AvatarUI
extends Control

@onready var hp_bar: TextureProgressBar = %hpBar
@onready var health_ui: HealthUI = %HealthUI
@onready var avatar_button: TextureButton = %AvatarButton

func update_stats(stats: Stats)-> void:
	health_ui.health_label.text = str(stats.health)
	health_ui.max_health_label.text = "/%s" % str(stats.max_health)
	health_ui.max_health_label.visible = health_ui.show_max_hp
	hp_bar.max_value = stats.max_health
	hp_bar.value = stats.health
