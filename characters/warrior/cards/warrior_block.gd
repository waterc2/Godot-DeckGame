extends Card

var base_block := 5


func get_default_tooltip() -> String:
	return tooltip_text % base_block


func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_block := player_modifiers.get_modified_value_by_type(base_block, Modifier.Type.BLOCK)
	if enemy_modifiers:
		modified_block = enemy_modifiers.get_modified_value_by_type(modified_block, Modifier.Type.BLOCK)
		
	return tooltip_text % modified_block

	
func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var block_effect := BlockEffect.new()
	block_effect.amount = base_block
	block_effect.sound = sound
	block_effect.execute(targets)