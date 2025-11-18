class_name Campfire
extends Control

const HEAL_PERCENTAGE := 0.3

@export var char_stats: CharacterStats

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rest_button: Button = %RestButton
@onready var description_label: Label = %Description


func _ready() -> void:
	# Set description text dynamically with percentage
	var percentage_string = "%d%%" % (HEAL_PERCENTAGE * 100)
	description_label.text = tr("+ 30% HP") % [percentage_string]


func _on_rest_button_pressed() -> void:
	rest_button.disabled = true
	char_stats.heal(ceili(char_stats.max_health * HEAL_PERCENTAGE))
	animation_player.play("fade_out")


# This is called from the AnimationPlayer
# at the end of 'fade-out'.
func _on_fade_out_finished() -> void:
	Events.campfire_exited.emit()
