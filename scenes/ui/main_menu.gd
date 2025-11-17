extends Control

const CHAR_SELECTOR_SCENE := preload("res://scenes/ui/character_selector.tscn")
const RUN_SCENE = preload("res://scenes/run/run.tscn")

@export var run_startup: RunStartup

@onready var continue_button: Button = %Continue
@onready var language_button: Button = %LanguageButton

const LANGUAGES = {
	"en": "English",
	"zh_CN": "中文"
}

func _ready() -> void:
	get_tree().paused = false
	continue_button.disabled = SaveGame.load_data() == null
	
	var os_locale = OS.get_locale()
	if os_locale == "zh_CN":
		TranslationServer.set_locale("zh_CN")
	else:
		TranslationServer.set_locale("en")
	
	_update_language_button_text()


func _on_language_button_pressed() -> void:
	var current_locale := TranslationServer.get_locale()
	if current_locale == "en":
		TranslationServer.set_locale("zh_CN")
	else:
		TranslationServer.set_locale("en")
	_update_language_button_text()


func _update_language_button_text() -> void:
	var current_locale := TranslationServer.get_locale()
	language_button.text = LANGUAGES.get(current_locale, "English")



func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)

func _on_continue_pressed() -> void:
	run_startup.type = RunStartup.Type.CONTINUED_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)
