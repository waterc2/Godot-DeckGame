extends Relic

@export var block_bonus := 3


func activate_relic(owner: RelicUI) -> void:
	var player := owner.get_tree().get_nodes_in_group("player")
	var block_effect := BlockEffect.new()
	block_effect.amount = block_bonus
	block_effect.sound = load("res://art/block.ogg")
	block_effect.execute(player)
	owner.flash()


func get_tooltip() -> String:
	var translated_text = tr(tooltip)
	# Format with block_bonus value
	return translated_text % [block_bonus]