class_name TrueStrengthStatus
extends Status

const STRENGTH_STATUS = preload("res://statuses/strength.tres")

var stacks_per_turn := 1

func apply_status(target: Node) -> void:
	print("applied true str form")
	
	var status_effect := StatusEffect.new()
	var strength := STRENGTH_STATUS.duplicate()
	strength.stacks = stacks_per_turn
	status_effect.status = strength
	status_effect.execute([target])
	
	status_applied.emit(self)


func get_tooltip() -> String:
	var translated_text = tr(tooltip)
	if translated_text.contains("%s"):
		# Use stacks_per_turn for True Strength Form
		return translated_text.replace("%s", "{0}").format([stacks_per_turn])
	
	return translated_text