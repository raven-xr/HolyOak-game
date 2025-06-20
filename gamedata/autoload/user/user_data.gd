extends Node

const SAVE_PATH: String = "user://save.cfg"

var progress: Dictionary[StringName, Dictionary] = {
	"LEVEL_1": {
		"is_completed": false,
		"stars": 0
	},
	"LEVEL_2": {
		"is_completed": false,
		"stars": 0
	},
	"LEVEL_3": {
		"is_completed": false,
		"stars": 0
	},
	"LEVEL_4": {
		"is_completed": false,
		"stars": 0
	},
	"LEVEL_5": {
		"is_completed": false,
		"stars": 0
	},
	"LEVEL_6": {
		"is_completed": false,
		"stars": 0
	},
}

func load_save() -> void:
	# If the save isn't verified, close the game
	if not verify_save():
		Global.game_controller.change_gui_scene("message")
		Global.game_controller.current_gui_scene.set_text("Критическая ошибка! Сохранение повреждено. Обратитесь к разработчику! Игра выключится самостоятельно через 5 секунд")
		# Close the game
		get_viewport().gui_disable_input = true # Makes player unable to interact with the GUI
		await get_tree().create_timer(5.0).timeout
		get_tree().quit()
	# Load the save
	var save: ConfigFile = ConfigFile.new()
	save.load(SAVE_PATH)
	# Load the progress
	for level in progress:
		for key in progress[level]:
			progress[level][key] = save.get_value(level, key)

func create_save() -> void:
	var save: ConfigFile = ConfigFile.new()
	for level in progress:
		for key in progress[level]:
			save.set_value(level, key, progress[level][key])
	save.save(SAVE_PATH)

func update_save() -> void:
	var save: ConfigFile = ConfigFile.new()
	save.load(SAVE_PATH)
	for level in progress:
		for key in progress[level]:
			save.set_value(level, key, progress[level][key])
	save.save(SAVE_PATH)

func verify_save() -> bool:
	var save: ConfigFile = ConfigFile.new()
	save.load(SAVE_PATH)
	# If the save file has more or less sections than levels, return the error
	if len(save.get_sections()) != LevelData.COUNT:
		return false
	# If there is a non-existent section, return the error
	for section in save.get_sections():
		if progress.get(section) == null:
			return false
	# If one of the levels has more than usual keys, return the error
	for level in save.get_sections():
		if len(save.get_section_keys(level)) != len(progress["LEVEL_1"].keys()):
			return false
	# If there are the usual count of the keys at each section, but one or both of them do not exist in the progress dictionary, return the error
	for level in save.get_sections():
		for key in save.get_section_keys(level):
			if not key in progress[level].keys():
				return false
	# If the data type of one of the keys does not match the desired data type, return the error
	for level in save.get_sections():
		for key in save.get_section_keys(level):
			if typeof(save.get_value(level, key)) != typeof(UserData.progress[level][key]):
				return false
	# If one of the levels was "passed" with more than 3 stars or less than 1 star 
	# or one of the levels wasn't passed but has more or less than 0 stars, return the error
	for level in save.get_sections():
		if (save.get_value(level, "is_completed") and (save.get_value(level, "stars") > 3 or save.get_value(level, "stars") < 1)) \
		or (not save.get_value(level, "is_completed") and save.get_value(level, "stars") != 0):
			return false
	return true
