extends Card

var base_heal := 10


func get_default_tooltip() -> String:
	return tooltip_text % base_heal
	

func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text % base_heal


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var block_effect := HealEffect.new()
	block_effect.amount = base_heal
	block_effect.sound = sound
	block_effect.execute(targets)