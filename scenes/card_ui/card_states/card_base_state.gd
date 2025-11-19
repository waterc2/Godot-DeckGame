class_name CardBaseState
extends CardState

static var tooltip_owner: CardUI

var mouse_over_card: bool = false

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
		
	card_ui.card_visuals.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	_release_sticky_tooltip_owner()
	card_ui.reparent_requested.emit(card_ui)
	card_ui.pivot_offset = Vector2.ZERO
	Events.tooltip_hide_requested.emit()

func on_gui_input(event: InputEvent) -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	if event is InputEventScreenTouch and event.pressed:
		_show_touch_tooltip()
		return
	if mouse_over_card and event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)


func on_mouse_entered() -> void:
	mouse_over_card = true
	if not card_ui.playable or card_ui.disabled:
		return
	card_ui.card_visuals.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)
	card_ui.request_tooltip()

	
func on_mouse_exited() -> void:
	mouse_over_card = false
	if not card_ui.playable or card_ui.disabled:
		return
	card_ui.card_visuals.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()
	_release_sticky_tooltip_owner()


func _show_touch_tooltip() -> void:
	_set_sticky_tooltip_owner()
	card_ui.card_visuals.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)
	card_ui.request_tooltip()


func _set_sticky_tooltip_owner() -> void:
	if tooltip_owner and tooltip_owner != card_ui and is_instance_valid(tooltip_owner):
		tooltip_owner.card_visuals.panel.set("theme_override_styles/panel", tooltip_owner.BASE_STYLEBOX)
	tooltip_owner = card_ui


func _release_sticky_tooltip_owner() -> void:
	if tooltip_owner == card_ui:
		tooltip_owner = null


static func clear_sticky_tooltip() -> void:
	if tooltip_owner and is_instance_valid(tooltip_owner):
		tooltip_owner.card_visuals.panel.set("theme_override_styles/panel", tooltip_owner.BASE_STYLEBOX)
	tooltip_owner = null
	Events.tooltip_hide_requested.emit()
