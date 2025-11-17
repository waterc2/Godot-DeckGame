class_name WinScreen
extends Control

const MAIN_MENU_PATH = "res://scenes/ui/main_menu.tscn"
@export var character: CharacterStats : set = set_character

@onready var character_portrait: TextureRect = %CharacterPortrait


func set_character(new_character: CharacterStats) -> void:
	character = new_character
	character_portrait.texture = character.portrait


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
	