class_name PauseMenu
extends CanvasLayer

signal save_and_quit

@onready var back_to_game_button: Button = %BackToGameButton
@onready var save_and_quit_button: Button = %SaveAndQuitButton
@onready var bgm_mute_checkbox: CheckBox = %BGMMuteCheckbox
@onready var sfx_mute_checkbox: CheckBox = %SFXMuteCheckbox
@onready var bgm_label: Label = %BGMLabel
@onready var sfx_label: Label = %SFXLabel

const AUDIO_BUS_BGM = "Music"
const AUDIO_BUS_SFX = "SFX"

func _ready() -> void:
	bgm_label.text = tr("UI_MUTE_BGM")
	sfx_label.text = tr("UI_MUTE_SFX")
	
	back_to_game_button.pressed.connect(_unpause)
	save_and_quit_button.pressed.connect(_on_save_and_quit_button_pressed)
	
	# Initialize checkbox states using the reliable is_bus_mute function.
	# Note: CheckBox `button_pressed` is true when checked. We want "checked" to mean "muted".
	bgm_mute_checkbox.button_pressed = AudioServer.is_bus_mute(AudioServer.get_bus_index(AUDIO_BUS_BGM))
	sfx_mute_checkbox.button_pressed = AudioServer.is_bus_mute(AudioServer.get_bus_index(AUDIO_BUS_SFX))
	
	# Connect checkbox signals
	bgm_mute_checkbox.toggled.connect(_on_bgm_mute_toggled)
	sfx_mute_checkbox.toggled.connect(_on_sfx_mute_toggled)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			_unpause()
		else:
			_pause()
			
		get_viewport().set_input_as_handled()


func _pause() -> void:
	show()
	get_tree().paused = true


func _unpause() -> void:
	hide()
	get_tree().paused = false


func _on_save_and_quit_button_pressed() -> void:
	get_tree().paused = false
	save_and_quit.emit()


func _on_bgm_mute_toggled(is_pressed: bool) -> void:
	# is_pressed is true when the box is checked, which means we want to mute it.
	SoundPlayer.toggle_bus_mute(AUDIO_BUS_BGM, is_pressed)


func _on_sfx_mute_toggled(is_pressed: bool) -> void:
	# is_pressed is true when the box is checked, which means we want to mute it.
	SoundPlayer.toggle_bus_mute(AUDIO_BUS_SFX, is_pressed)
