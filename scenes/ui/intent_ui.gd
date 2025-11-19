class_name IntentUI
extends HBoxContainer


@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label

var current_intent: Intent


func update_intent(intent: Intent) -> void:
	if not intent:
		hide()
		return	
	current_intent = intent
	icon.texture = intent.icon
	icon.visible = icon.texture != null
	label.text = str(intent.current_text)
	label.visible = intent.current_text.length() > 0
	show()


func _on_mouse_entered() -> void:
	if not current_intent or current_intent.tooltip.is_empty():
		return
	
	# First translate the tooltip text
	var formatted_text := tr(current_intent.tooltip)
	
	# Then format with current values if it has placeholders
	if "%s" in formatted_text:
		formatted_text = formatted_text % current_intent.current_text
	
	# Emit tooltip request event
	Events.card_tooltip_requested.emit(current_intent.icon, formatted_text)


func _on_mouse_exited() -> void:
	Events.tooltip_hide_requested.emit()