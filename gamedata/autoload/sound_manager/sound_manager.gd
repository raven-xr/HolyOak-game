extends Node

@onready var click: AudioStreamPlayer = $UserInterface/Click
@onready var success: AudioStreamPlayer = $UserInterface/Success
@onready var victory: AudioStreamPlayer = $UserInterface/Victory
@onready var defeat: AudioStreamPlayer = $UserInterface/Defeat

@onready var music_main: AudioStreamPlayer = $"Music/Music Main"
@onready var music_idle: AudioStreamPlayer = $"Music/Music Idle"

func disable_music() -> void:
	music_main.stop()
	music_idle.stop()
	reset_volume()

func reset_volume() -> void:
	music_main.volume_db = -20
	music_idle.volume_db = -40
