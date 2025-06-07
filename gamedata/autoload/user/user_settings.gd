extends Node

# Default settings
const DEFAULT_MASTER_VOLUME: float = 1.0
const DEFAULT_MUSIC_VOLUME: float = 0.65
const DEFAULT_SFX_VOLUME: float = 1.0
#const DEFAULT_GUI_SCALE: float = 1.0

# Audiobuses
var master_bus_idx: int = AudioServer.get_bus_index("Master")
var music_bus_idx: int = AudioServer.get_bus_index("Music")
var sfx_bus_idx: int = AudioServer.get_bus_index("SFX")
## Equals [0.0; 1.0] (linear)
var master_volume: float = 1.0:
	set(value):
		master_volume = value
		property_changed.emit()
		AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(value))
## Equals [0.0; 1.0] (linear)
var music_volume: float = 0.65:
	set(value):
		music_volume = value
		property_changed.emit()
		AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(value))
## Equals [0.0; 1.0] (linear)
var sfx_volume: float = 1.0:
	set(value):
		sfx_volume = value
		property_changed.emit()
		AudioServer.set_bus_volume_db(sfx_bus_idx, linear_to_db(value))
## Equals {0.8; 1.0; 1.2; 1.4}
var gui_scale: float = 1.0:
	set(value):
		gui_scale = value
		property_changed.emit()

signal property_changed()

const SETTINGS_PATH: String = "user://SETTINGS.cfg"

func _ready() -> void:
	connect("property_changed", Callable(self, "_on_property_changed"))
	if FileAccess.file_exists(SETTINGS_PATH):
		load_settings()
	else:
		# Autoscaling, after autoscaling the "property_changes" signal will be emited
		# and a ConfigFile with settings will be created
		gui_scale = match_scale()

func load_settings() -> void:
	var settings: ConfigFile = ConfigFile.new()
	settings.load(SETTINGS_PATH)
	master_volume = settings.get_value("VOLUME", "MASTER_VOLUME")
	music_volume = settings.get_value("VOLUME", "MUSIC_VOLUME")
	sfx_volume = settings.get_value("VOLUME", "SFX_VOLUME")
	gui_scale = settings.get_value("GUI", "GUI_SCALE")

func save_settings() -> void:
	var settings: ConfigFile = ConfigFile.new()
	settings.set_value("VOLUME", "MASTER_VOLUME", master_volume)
	settings.set_value("VOLUME", "MUSIC_VOLUME", music_volume)
	settings.set_value("VOLUME", "SFX_VOLUME", sfx_volume)
	settings.set_value("GUI", "GUI_SCALE", gui_scale)
	settings.save(SETTINGS_PATH)

func _on_property_changed() -> void:
	save_settings()

func match_scale() -> float:
	if OS.get_name() == "Android":
		return 1.4
	else:
		return 1.0
