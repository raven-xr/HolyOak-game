extends Node



@onready var click: AudioStreamPlayer = $"User Interface/Click"
@onready var success: AudioStreamPlayer = $"User Interface/Success"
@onready var victory: AudioStreamPlayer = $"User Interface/Victory"
@onready var defeat: AudioStreamPlayer = $"User Interface/Defeat"

@onready var music_main: AudioStreamPlayer = $"Music/Music Main"
@onready var music_idle: AudioStreamPlayer = $"Music/Music Idle"
@onready var music_fight: AudioStreamPlayer = $"Music/Music Fight"



func disable_music() -> void:
	music_main.stop()
	music_idle.stop()
	music_fight.stop()
	reset_volume()

func reset_volume() -> void:
	music_main.volume_db = -20
	music_idle.volume_db = -40
	music_fight.volume_db = -40
