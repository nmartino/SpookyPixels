class_name WeaponInventory
extends Control
var InventorySize = 12
@onready var weapon_slots: Array[Control] = [%SlotWeapon, %SlotWeapon2, %SlotWeapon3, %SlotWeapon4]
@onready var rune_slots: GridContainer = %RuneSlots
@onready var back_button: Button = $BackButton
@onready var weapon_info_button: Button = %WeaponInfoButton
@onready var weapon_panel: Panel = %WeaponPanel
@onready var back_button_weapon_panel: Button = %BackButtonWeaponPanel
@onready var rune_slot_1_tooltip: RichTextLabel = %RuneSlot1Tooltip
@onready var rune_slot_2_tooltip: RichTextLabel = %RuneSlot2Tooltip
@onready var rune_slot_3_tooltip: RichTextLabel = %RuneSlot3Tooltip
@onready var rune_slot_4_tooltip: RichTextLabel = %RuneSlot4Tooltip
@onready var character_stats_label: RichTextLabel = %characterStatsLabel
@onready var character_stats: CharacterStats
@onready var runes_labels: Control = %runesLabels
@onready var character_avatar: TextureRect = %CharacterAvatar


const SLOT_INVENTORY = preload("res://art/sounds/slot_inventory.wav")
const SLOT_WEAPON = preload("res://art/sounds/slot_weapon.wav")
const CHAR_STAT_LABEL_TEXT ="[color='55ffff']Name[/color]: %s\n[color='55ffff']Weapon Name[/color]: %s\n[color='55ffff']Hp[/color]: %s\n[color='55ffff']Cards Per Turn[/color]: %s"
const RUNE_SLOT_TEXT = "[color='55ffff']Rune slot[/color] [color='ff55ff']%s[/color]: %s"

var unattachedRunes: Dictionary[Control, InventoryRune] = {}
var attachedRunes: Dictionary[Control, InventoryRune] = {}
var weapon: BaseWeapon

func _ready() -> void:
	back_button.pressed.connect(hide)
	weapon_info_button.pressed.connect(_on_weapon_info_pressed)
	back_button_weapon_panel.pressed.connect(_on_back_weapon_panel)
	for slot in weapon_slots:
		slot.rune_panel.attachment_dragged.connect(runeEquiped.bind(slot))
	for slot in rune_slots.get_children():
		slot.inventory_slot.attachment_dragged.connect(runeMoved.bind(slot))

func show_weapon_inventory(character: CharacterStats) ->void:
	character_stats = character
	weapon = character.weapon
	character_avatar.texture = character.avatar
	for slot in attachedRunes:
		attachedRunes[slot].queue_free()
	attachedRunes.clear()
	for i in weapon.attachments.size():
		var attachment = weapon.attachments[i]
		var item := InventoryRune.new()
		item.init(attachment)
		var slot = weapon_slots[i]
		slot.rune_panel.add_child(item)
		attachedRunes[slot as Control] = item
	show()

func _on_back_button_pressed() -> void:
	hide()

func register_rune(attachment: WeaponAttachment) ->void:
	var item := InventoryRune.new()
	item.init(attachment)
	for slot in rune_slots.get_children():
		if not slot is Control:
			continue
		if not slot in unattachedRunes:
			slot.inventory_slot.add_child(item)
			unattachedRunes[slot as Control] = item
			return

func runeEquiped(item: InventoryRune, slot: Control)->void:
	unregister_rune(item)
	attachedRunes[slot] = item
	weapon.add_attachment(item.data)
	SFXPlayer.play(SLOT_INVENTORY)

func runeMoved(item: InventoryRune, slot:Control) ->void:
	unregister_rune(item)
	unattachedRunes[slot] = item
	SFXPlayer.play(SLOT_INVENTORY)
	
func unregister_rune(item: InventoryRune)-> void:
	var slot = attachedRunes.find_key(item)
	if slot != null:
		attachedRunes.erase(slot)
		weapon.remove_attachment(item.data)
	slot = unattachedRunes.find_key(item)
	if slot != null:
		unattachedRunes.erase(slot)

func _on_weapon_info_pressed()->void:
	character_stats_label.text = CHAR_STAT_LABEL_TEXT % [character_stats.character_name,
	character_stats.weapon.name, character_stats.max_health, character_stats.cards_per_turn]
	write_rune_data(character_stats.weapon.attachments)
	weapon_panel.show()

func write_rune_data(attachments: Array[WeaponAttachment])->void:
	for i in runes_labels.get_child_count():
		if i >= attachments.size():
			runes_labels.get_child(i).text = RUNE_SLOT_TEXT % [i+1, "No Data"]
		else:
			runes_labels.get_child(i).text = RUNE_SLOT_TEXT % [i+1, attachments[i].tooltip]

func _on_back_weapon_panel() ->void:
	weapon_panel.hide()
	
