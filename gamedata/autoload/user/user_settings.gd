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

const SETTINGS_PATH: String = "user://settings.cfg"

func _ready() -> void:
	connect("property_changed", Callable(self, "_on_property_changed"))

func load_settings() -> void:
	if not verify_settings():
		Global.game_controller.change_gui_scene("message")
		Global.game_controller.current_gui_scene.set_text("Критическая ошибка! Данные настроек повреждены. Обратитесь к разработчику! Игра выключится самостоятельно через 5 секунд")
		# Close the game
		get_viewport().gui_disable_input = true # Makes player unable to interact with the GUI
		await get_tree().create_timer(5.0).timeout
		get_tree().quit()
	var settings: ConfigFile = ConfigFile.new()
	settings.load(SETTINGS_PATH)
	master_volume = settings.get_value("VOLUME", "master_volume")
	music_volume = settings.get_value("VOLUME", "music_volume")
	sfx_volume = settings.get_value("VOLUME", "sfx_volume")
	gui_scale = settings.get_value("GUI", "gui_scale")

func save_settings() -> void:
	var settings: ConfigFile = ConfigFile.new()
	settings.set_value("VOLUME", "master_volume", master_volume)
	settings.set_value("VOLUME", "music_volume", music_volume)
	settings.set_value("VOLUME", "sfx_volume", sfx_volume)
	settings.set_value("GUI", "gui_scale", gui_scale)
	settings.save(SETTINGS_PATH)

func verify_settings() -> bool:
	var settings: ConfigFile = ConfigFile.new()
	settings.load(SETTINGS_PATH)
	# If the settings file has more than two sections, return the error
	if len(settings.get_sections()) != 2:
		return false
	# If there is a non-existent section, return the error
	for section in settings.get_sections():
		if not section in ["VOLUME", "GUI"]:
			return false
	# If one of the levels has more than usual keys, return the error
	if len(settings.get_section_keys("VOLUME")) != 3:
		return false
	if len(settings.get_section_keys("GUI")) != 1:
		return false
	# If there are usual count of the keys at each section, but one or both of them do not exist in the progress dictionary, return the error
	for section in settings.get_sections():
		for key in settings.get_section_keys(section):
			if get(key) == null:
				return false
	# If the data type of one of the keys does not match the desired data type, return the error
	for section in settings.get_sections():
		for key in settings.get_section_keys(section):
			if typeof(settings.get_value(section, key)) != typeof(get(key)):
				return false
	# If one of the values isn't real, return the error
	for volume in settings.get_section_keys("VOLUME"):
		if settings.get_value("VOLUME", volume) > 1.0 or settings.get_value("VOLUME", volume) < 0.0:
			return false
	if not settings.get_value("GUI", "gui_scale") in [0.8, 1.0, 1.2, 1.4]:
		return false
	return true

func _on_property_changed() -> void:
	save_settings()

func match_scale() -> float:
	if OS.get_name() == "Android":
		return 1.4
	else:
		return 1.0
