extends EnemyAction

const MUSCLE_STATUS = preload("res://statuses/strength.tres")

@export var stacks_per_action := 2

var turn_count := 0


func _ready() -> void:
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)


func _on_enemy_turn_ended() -> void:
	turn_count += 1


func is_performable() -> bool:
	# Execute on turns 1, 3, and 5, then stop
	return turn_count == 1 or turn_count == 3 or turn_count == 5


func perform_action() -> void:
	if not enemy:
		return
	
	# Get all enemies in the battle
	var all_enemies := get_tree().get_nodes_in_group("enemies")
	
	# Apply strength buff to all enemies
	for target_enemy in all_enemies:
		if not target_enemy or not target_enemy is Enemy:
			continue
		var status_effect := StatusEffect.new()
		var muscle := MUSCLE_STATUS.duplicate()
		muscle.stacks = stacks_per_action
		status_effect.status = muscle
		status_effect.execute([target_enemy])
	
	SFXPlayer.play_sfx(sound)
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)


func update_intent_text() -> void:
	if intent:
		intent.current_text = intent.base_text % stacks_per_action

