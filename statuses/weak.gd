class_name WeakStatus
extends Status

const MODIFIER := -0.25

func initialize_status(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var dmg_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmg_dealt_modifier, "No dmg dealt modifier on %s" % target)

	var weak_modifier_value := dmg_dealt_modifier.get_value("weak")

	if not weak_modifier_value:
		weak_modifier_value = ModifierValue.create_new_modifier("weak", ModifierValue.Type.PERCENT)
		weak_modifier_value.percent_value = MODIFIER
		dmg_dealt_modifier.add_new_value(weak_modifier_value)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(dmg_dealt_modifier))


func _on_status_changed(dmg_dealt_modifier: Modifier) -> void:
	if duration <= 0 and dmg_dealt_modifier:
		dmg_dealt_modifier.remove_value("weak")