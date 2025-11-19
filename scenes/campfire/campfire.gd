class_name Campfire
extends Control

const HEAL_PERCENTAGE := 0.3

@export var char_stats: CharacterStats

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rest_button: Button = %RestButton
@onready var description_label: Label = %Description


func _ready() -> void:
	# Set description text dynamically with percentage
	var percentage_value = int(HEAL_PERCENTAGE * 100)
	var translated_text = tr("CAMPFIRE_REST_HEAL_TEXT")
	# Replace %s with the actual percentage value
	description_label.text = translated_text.replace("%s", str(percentage_value))


func _on_rest_button_pressed() -> void:
	rest_button.disabled = true
	char_stats.heal(ceili(char_stats.max_health * HEAL_PERCENTAGE))
	animation_player.play("fade_out")


# This is called from the AnimationPlayer
# at the end of 'fade-out'.
func _on_fade_out_finished() -> void:
	Events.campfire_exited.emit()
