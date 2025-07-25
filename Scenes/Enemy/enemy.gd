class_name Enemy
extends Area2D

const ARROW_OFFSET := 5
const INVERTED_SPRITE_MATERIAL := preload("res://art/white_sprite_material.tres")
const ATTACKFX := preload("res://Scenes/CardFxs/attack_fx.tscn")



@export var stats: EnemyStats : set = set_enemy_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $Arrow
@onready var stats_ui: StatsUI = $StatsUI as StatsUI
@onready var intent_ui: IntentUI = $IntentUI as IntentUI
@onready var status_handler: StatusHandler = $StatusHandler
@onready var modifier_handler: ModifierHandler = $ModifierHandler

var enemy_action_picker: EnemyActionPicker
var current_action: EnemyAction : set = set_current_action

func _ready() -> void:
	status_handler.status_owner = self


func set_current_action(value: EnemyAction)-> void:
	current_action = value
	update_intent()

func set_enemy_stats(value: EnemyStats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		stats.stats_changed.connect(update_action)
		
	update_enemy()

func setup_ai()-> void:
	if enemy_action_picker:
		enemy_action_picker.queue_free()
	
	var new_action_picker: EnemyActionPicker = stats.ai.instantiate()
	add_child(new_action_picker)
	enemy_action_picker = new_action_picker
	enemy_action_picker.enemy = self


func update_stats() -> void:
	stats_ui.update_stats(stats)

func update_action() -> void:
	if not enemy_action_picker:
		return
	
	if not current_action:
		current_action = enemy_action_picker.get_action()
		return
	
	var new_conditional_action := enemy_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action

func update_enemy() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready
		
	sprite_2d.texture = stats.art
	arrow.position = Vector2.RIGHT * (sprite_2d.get_rect().size.x/2 + ARROW_OFFSET)
	setup_ai()
	update_stats()

func update_intent() -> void:
	if current_action:
		current_action.update_intent_text()
		intent_ui.update_intent(current_action.intent)

func do_turn() -> void:
	stats.block = 0
	
	if not current_action:
		return
	
	current_action.perform_action()


func take_damage(damage:int, which_modifier: Modifier.Type, type: DamageEffect.Type)->void:
	if stats.health <=0:
		return
	
	var modified_damage := modifier_handler.get_modified_value(damage, which_modifier)
	
	var tween := create_tween()
	tween.tween_callback(Shaker.shake.bind(self,16,0.15))
	tween.tween_callback(stats.take_damage.bind(modified_damage))
	tween.tween_interval(0.17)
	sprite_2d.texture = stats.hurt
	
	var attackFx = ATTACKFX.instantiate()
	add_child(attackFx)
	match type:
		DamageEffect.Type.FIRE:
			attackFx.explosion.play("explosion_fire")
		DamageEffect.Type.ICE:
			attackFx.explosion.play("Ice_attack")
		DamageEffect.Type.PHYSICAL:
			attackFx.explosion.play("enemy_fx")
		DamageEffect.Type.ARROW:
			attackFx.global_position.y = attackFx.global_position.y - 25
			attackFx.explosion.play("arrow_strike")
		DamageEffect.Type.LIGHTING:
			attackFx.global_position.y = attackFx.global_position.y - 30
			attackFx.explosion.play("lighting_strike")
		DamageEffect.Type.NONE_FX:
			attackFx.explosion.play("enemy_fx")
	attackFx.explosion.animation_finished.connect(
		func():
			
			attackFx.queue_free()
	)
	
	tween.finished.connect(
		func():
			#sprite_2d.material = null
			sprite_2d.texture = stats.art
			
			if stats.health <= 0:
				Events.enemy_died.emit(self)
				queue_free()
	)


func _on_area_entered(_area: Area2D) -> void:
	arrow.show()


func _on_area_exited(_area: Area2D) -> void:
	arrow.hide()
