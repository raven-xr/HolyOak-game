extends Node

const SAVE_PATH: String = "user://SAVE.cfg"

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

func _ready() -> void:
	if FileAccess.file_exists(UserData.SAVE_PATH):
		load_save()
	else:
		create_save()

func load_save() -> void:
	var save: ConfigFile = ConfigFile.new()
	save.load(SAVE_PATH)
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
