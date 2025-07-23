extends Node
@warning_ignore_start("unused_signal")
# Card-related events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested

#player-related events
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
signal player_hit
signal player_died

#enemy related events
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended
signal enemy_died(enemy:Enemy)

#Battle-related events
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal battle_won
signal status_tooltip_requested(statuses: Array[Status])

#Map related events
signal map_exited(room: Room)

#shop related events
signal shop_entered(shop: Shop)
signal shop_card_bought(card:Card, gold_cost: int)
signal shop_exited

#campfire related events
signal campfire_exited

#battle reward related events
signal battle_reward_exited

#treasure room related events
signal treasure_room_exited()

#Weapon-related events
signal weapon_start_of_combat_activation
signal weapon_combat_activation(card: CardUI)
signal weapon_end_of_combat_activation

#random-event-room-related events
signal event_room_exited

#weapon-rune-inventory-related events
signal inventory_exited
@warning_ignore_restore("unused_signal")
