extends Card

const VULNERABLE_STATUS = preload("res://statuses/vulnerable.tres")

var base_damage := 4
var vulnerable_duration := 2


func get_default_tooltip() -> String:
	#return tooltip_text.format(str(base_damage), str(vulnerable_duration))
	return tooltip_text % [base_damage, vulnerable_duration]


func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value_by_type(base_damage, Modifier.Type.DMG_DEALT)
	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value_by_type(modified_dmg, Modifier.Type.DMG_TAKEN)
		
	return tooltip_text % [modified_dmg, vulnerable_duration]


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value_by_type(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)
	
	var status_effect := StatusEffect.new()
	var vulnerable := VULNERABLE_STATUS.duplicate()
	vulnerable.duration = vulnerable_duration
	status_effect.status = vulnerable
	status_effect.execute(targets)
