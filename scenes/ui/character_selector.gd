extends Control

const RUN_SCENE = preload("res://scenes/run/run.tscn")
const ASSASSIN_STATS :=preload("res://characters/assassin/assassin.tres")
const WIZARD_STATS :=preload("res://characters/wizard/wizard.tres")
const WARRIOR_STATS :=preload("res://characters/warrior/warrior.tres")

@export var run_startup: RunStartup

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var character_portrait: TextureRect = %CharacterPortrait
@onready var start_button: Button = $StartButton

var current_character: CharacterStats : set = set_current_character

func _ready() -> void:
	start_button.text = tr("character_selector.start")
	set_current_character(WARRIOR_STATS)

func set_current_character(new_character: CharacterStats) -> void:
	current_character = new_character
	title.text = current_character.character_name
	description.text = current_character.description
	character_portrait.texture = current_character.portrait


func _on_assassin_button_pressed() -> void:
	current_character = ASSASSIN_STATS


func _on_wizzard_button_pressed() -> void:
	current_character = WIZARD_STATS


func _on_warrior_button_pressed() -> void:
	current_character = WARRIOR_STATS

func _on_start_button_pressed() -> void:
	print("Start new Run with %s" % current_character.character_name)
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.picked_character = current_character
	get_tree().change_scene_to_packed(RUN_SCENE)