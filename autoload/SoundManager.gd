extends Node

@onready var click = $UserInterface/Click
@onready var success = $UserInterface/Success
@onready var victory = $UserInterface/Victory
@onready var defeat = $UserInterface/Defeat
@onready var music_main = $"Music/Music Main"
@onready var music_idle = $"Music/Music Idle"
@onready var music_fight = $"Music/Music Fight"

func disable_music():
	music_main.stop()
	music_idle.stop()
	music_fight.stop()
