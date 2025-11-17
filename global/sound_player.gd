extends Node

signal music_finished

var _music_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
@export var sfx_player_pool_size := 10

# A sample sound to play when unmuting SFX to test the volume
@export var sfx_test_sound: AudioStream

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	add_child(_music_player)
	_music_player.bus = "Music" # Assuming a "Music" bus exists
	_music_player.finished.connect(music_finished.emit)
	
	for i in range(sfx_player_pool_size):
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.bus = "SFX" # Assuming an "SFX" bus exists
		add_child(sfx_player)
		_sfx_players.append(sfx_player)


func play_music(audio: AudioStream) -> void:
	if not audio:
		return
	# Avoid restarting the music if it's already playing the same stream
	if _music_player.stream == audio and _music_player.is_playing():
		return
	_music_player.stream = audio
	_music_player.play()

func play_sfx(audio: AudioStream) -> void:
	if not audio:
		return
	for player in _sfx_players:
		if not player.is_playing():
			player.stream = audio
			player.play()
			return
	# Fallback: if all players are busy, just use the first one.
	# This might cut off another sound, but it's better than not playing.
	_sfx_players[0].stream = audio
	_sfx_players[0].play()


func stop() -> void:
	_music_player.stop()
	for player in _sfx_players:
		player.stop()

func set_bus_volume(bus_name: String, volume_percent: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx != -1:
		# Clamp the value to avoid -inf dB which mutes the bus completely
		var linear_vol = clamp(volume_percent / 100.0, 0.0001, 1.0)
		if volume_percent == 0:
			linear_vol = 0
		var volume_db = linear_to_db(linear_vol)
		AudioServer.set_bus_volume_db(bus_idx, volume_db)

func get_bus_volume(bus_name: String) -> float:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx != -1:
		var volume_db = AudioServer.get_bus_volume_db(bus_idx)
		return db_to_linear(volume_db) * 100.0
	return 0.0

func toggle_bus_mute(bus_name: String, muted: bool) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx == -1:
		return
	
	AudioServer.set_bus_mute(bus_idx, muted)
	
	# If unmuting SFX, play a test sound
	if bus_name == "SFX" and not muted:
		if sfx_test_sound:
			play_sfx(sfx_test_sound)
		else:
			push_warning("SFX test sound not set in SoundPlayer.")
