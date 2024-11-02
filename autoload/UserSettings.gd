extends Node

# Buses
var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")
## Equals [0.0; 1.0] (linear)
var master_volume: float = 1.0:
	set(value):
		master_volume = value
		parameter_changed.emit()
		AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))
## Equals [0.0; 1.0] (linear)
var music_volume: float = 1.0:
	set(value):
		music_volume = value
		parameter_changed.emit()
		AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
## Equals [0.0; 1.0] (linear)
var sfx_volume: float = 1.0:
	set(value):
		sfx_volume = value
		parameter_changed.emit()
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))
## Equals {0.8; 1.0; 1.2; 1.4}
var gui_scale: float = 1.0:
	set(value):
		gui_scale = value
		parameter_changed.emit()



signal parameter_changed()



func _ready():
	connect("parameter_changed", Callable(self, "_on_parameter_changed"))
	load_settings()

func load_settings():
	if FileAccess.file_exists(UserData.SETTINGS_PATH):
		var settings = FileAccess.open(UserData.SETTINGS_PATH, FileAccess.READ)
		master_volume = settings.get_var()
		music_volume = settings.get_var()
		sfx_volume = settings.get_var()
		gui_scale = settings.get_var()

func _on_parameter_changed():
	var settings = FileAccess.open(UserData.SETTINGS_PATH, FileAccess.WRITE)
	settings.store_var(master_volume)
	settings.store_var(music_volume)
	settings.store_var(sfx_volume)
	settings.store_var(gui_scale)
