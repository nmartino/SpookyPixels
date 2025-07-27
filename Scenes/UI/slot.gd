class_name WeaponSlot
extends TextureRect
const GEM_SLOT_SMALL = preload("res://art/1bit/XaviArt/gemslots/gem-slot03-base.png")
const GEM_SLOT_BIG = preload("res://art/1bit/XaviArt/gemslots/gem-slot03-hover.png")

var animacion = ["girar1","girar2","girar3"]
var hasItem := false
@onready var animation_player: AnimationPlayer = $AnimatedAura/AnimationPlayer
@onready var rune_panel: PanelContainer = $RunePanel
@onready var small_big: AnimatedSprite2D = $smallBig

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if rune_panel.get_child_count() > 0:
		small_big.play("big")
		hasItem = true
	elif rune_panel.get_child_count() == 0 and hasItem:
		small_big.play("small")
		hasItem = false

func _ready() -> void:
	animation_player.play(animacion.pick_random())


func _on_rune_panel_mouse_entered() -> void:
	small_big.play("big")

func _on_rune_panel_mouse_exited() -> void:
	small_big.play("small")
