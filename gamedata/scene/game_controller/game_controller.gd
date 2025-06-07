extends Node
class_name GameController

@export_group("2D Scenes")
@export var main_menu: PackedScene
@export var level_1: PackedScene
@export var level_2: PackedScene
@export var level_3: PackedScene
@export_group("GUI Scenes")
@export var settings: PackedScene
@export var message: PackedScene
@export var confirmation: PackedScene

@onready var world_2d: Node2D = $World2D
@onready var gui: Control = $GUI

var current_2d_scene
var current_gui_scene

func _ready() -> void:
	Global.game_controller = self
	change_2d_scene("main_menu")
	# Load save
	if FileAccess.file_exists(UserData.SAVE_PATH):
		UserData.load_save()
	else:
		UserData.create_save()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") and current_gui_scene and current_gui_scene.can_be_closed:
		current_gui_scene.close()
		current_gui_scene = null

## Scene name must be determined by the file name without the extension:[br]
## e.g. main_menu, level_1
func change_2d_scene(scene_name: StringName, delete: bool = true, keep_running: bool = false) -> void:
	if current_2d_scene:
		if delete:
			current_2d_scene.queue_free() # Deletes node entirely
		elif keep_running:
			current_2d_scene.visible = false # Hides node
		else:
			world_2d.remove_child(current_2d_scene) # Removes node from the tree, but keeps in memory
	var new_scene = get(scene_name).instantiate()
	current_2d_scene = new_scene
	world_2d.add_child(new_scene)

## You should change GUI Scene with GameConroller only if it's really needed (can be used in any scene, e. g. console)
## Scene name must be determined by the file name without the extension:[br]
## e.g. victory_menu, settings
func change_gui_scene(scene_name: StringName, delete: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene:
		if delete:
			current_gui_scene.queue_free() # Deletes node entirely
		elif keep_running:
			current_gui_scene.visible = false # Hides node
		else:
			gui.remove_child(current_gui_scene) # Removes node from the tree, but keeps in memory
	var new_scene = get(scene_name).instantiate()
	current_gui_scene = new_scene
	gui.add_child(new_scene)
