class_name VulnerableStatus
extends Status

const MODIFIER := 0.4


func initialize_status(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var dmg_taken_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_TAKEN)
	assert(dmg_taken_modifier, "No dmg taken modifier on %s" % target)

	var vulnerable_modifier_value := dmg_taken_modifier.get_value("vulnerable")

	if not vulnerable_modifier_value:
		vulnerable_modifier_value = ModifierValue.create_new_modifier("vulnerable", ModifierValue.Type.PERCENT)
		vulnerable_modifier_value.percent_value = MODIFIER
		dmg_taken_modifier.add_new_value(vulnerable_modifier_value)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(dmg_taken_modifier))


func _on_status_changed(dmg_taken_modifier: Modifier) -> void:
	if duration <= 0 and dmg_taken_modifier:
		dmg_taken_modifier.remove_value("vulnerable")


func get_tooltip() -> String:
	var translated_text = tr(tooltip)
	# Convert MODIFIER (0.4) to percentage string (40%)
	var percentage_value = MODIFIER * 100
	var percentage_string = "%d%%" % percentage_value
	# Format with percentage first, then duration
	return translated_text % [percentage_string, duration]