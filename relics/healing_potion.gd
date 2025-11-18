extends Relic

@export var heal_amount := 6


func activate_relic(owner: RelicUI) -> void:
	var player := owner.get_tree().get_first_node_in_group("player") as Player
	if player:
		player.stats.heal(heal_amount)
		owner.flash()


func get_tooltip() -> String:
	var translated_text = tr(tooltip)
	# Format with heal_amount value
	return translated_text % [heal_amount]