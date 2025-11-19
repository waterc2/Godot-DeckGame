extends Card

var base_damage := 3
var attack_times := 3


func get_default_tooltip() -> String:
	return tr(tooltip_text) % [base_damage, attack_times]


func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value_by_type(base_damage, Modifier.Type.DMG_DEALT)
	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value_by_type(modified_dmg, Modifier.Type.DMG_TAKEN)
		
	return tr(tooltip_text) % [modified_dmg, attack_times]


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value_by_type(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	randomize() # Ensure the random number generator is properly initialized
	for i in range(attack_times):
		var random_index = randi() % targets.size()
		damage_effect.execute([targets[random_index]])