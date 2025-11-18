extends Relic

const MANA_GAIN := 1

func activate_relic(owner: RelicUI) -> void:
	Events.player_after_turn_reset.connect(_add_mana.bind(owner), CONNECT_ONE_SHOT)


func _add_mana(owner: RelicUI) -> void:
	var player := owner.get_tree().get_first_node_in_group("player") as Player
	if player:
		player.stats.mana += MANA_GAIN
		owner.flash()


func get_tooltip() -> String:
	var translated_text = tr(tooltip)
	# Format with MANA_GAIN value
	return translated_text % [MANA_GAIN]