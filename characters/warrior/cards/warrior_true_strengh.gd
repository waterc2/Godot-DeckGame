extends Card

const TRUE_STRENGTH_FORM_STATUS = preload("res://statuses/true_strength_form.tres")

var strength_bonus := 1


func get_default_tooltip() -> String:
	return tr(tooltip_text) % strength_bonus
	

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tr(tooltip_text) % strength_bonus


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var true_strength := TRUE_STRENGTH_FORM_STATUS.duplicate()
	status_effect.status = true_strength
	status_effect.execute(targets)