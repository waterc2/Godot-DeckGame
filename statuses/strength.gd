class_name StrengthStatus
extends Status

var _target: Node
var _is_initialized := false

func initialize_status(target: Node) -> void:
	_target = target
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed)
	_is_initialized = true
	_on_status_changed()


func _on_status_changed() -> void:
	if not _is_initialized or not _target:
		return
		
	if not _target.has_method("get") or not _target.get("modifier_handler"):
		return
		
	var dmg_dealt_modifier: Modifier = _target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	if not dmg_dealt_modifier:
		return
		
	var strength_modifier_value := dmg_dealt_modifier.get_value("strength")	
	if not strength_modifier_value:
		strength_modifier_value = ModifierValue.create_new_modifier("strength", ModifierValue.Type.FLAT)
		dmg_dealt_modifier.add_child(strength_modifier_value)
	
	# Update the modifier value with current stacks
	strength_modifier_value.flat_value = stacks
