class_name WeaponInventory
extends Control
var InventorySize = 12
@onready var weapon_slots: Array[Control] = [%SlotWeapon, %SlotWeapon2, %SlotWeapon3, %SlotWeapon4]
@onready var rune_slots: GridContainer = %RuneSlots
@onready var back_button: Button = $BackButton

var unattachedRunes: Dictionary[Control, InventoryRune] = {}
var attachedRunes: Dictionary[Control, InventoryRune] = {}
var weapon: BaseWeapon

func _ready() -> void:
	back_button.pressed.connect(hide)
	for slot in weapon_slots:
		slot.rune_panel.attachment_dragged.connect(runeEquiped.bind(slot))
	for slot in rune_slots.get_children():
		slot.attachment_dragged.connect(runeMoved.bind(slot))

func show_weapon_inventory(p_weapon: BaseWeapon) ->void:
	weapon = p_weapon
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
			slot.add_child(item)
			unattachedRunes[slot as Control] = item
			return

func runeEquiped(item: InventoryRune, slot: Control)->void:
	unregister_rune(item)
	attachedRunes[slot] = item
	weapon.add_attachment(item.data)

func runeMoved(item: InventoryRune, slot:Control) ->void:
	unregister_rune(item)
	unattachedRunes[slot] = item
	
func unregister_rune(item: InventoryRune)-> void:
	var slot = attachedRunes.find_key(item)
	if slot != null:
		attachedRunes.erase(slot)
		weapon.remove_attachment(item.data)
	slot = unattachedRunes.find_key(item)
	if slot != null:
		unattachedRunes.erase(slot)
