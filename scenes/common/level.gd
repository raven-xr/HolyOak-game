extends Node2D
class_name Level

# Enumerate
enum States {
	TUTORIAL,
	IDLE,
	FIGHT
}

# Scenes
@export var hint_scene: PackedScene
@export var path_follow_2d_scene: PackedScene
@export var ork_scene: PackedScene
@export var message_scene: PackedScene
@export var defeat_menu_scene: PackedScene
@export var victory_menu_scene: PackedScene
@export var game_menu_scene: PackedScene

# Strings
@export var next_level_path: String = "res://scenes/main_menu/main_menu.tscn"

# Nodes
@onready var enemies = $Enemies
@onready var towers = $Towers
@onready var user_interface = $UserInterface

@onready var menu = $UserInterface/Menu

@onready var menu_button = $"UserInterface/Menu/Button"

@onready var data: Dictionary = LevelData.get(name.to_upper())

var wave_count: int
var is_enemy_spawning: bool = false
var state: int:
	set(value):
		state = value
		match state:
			States.IDLE: idle_state(10.0)
			States.FIGHT: fight_state()
var current_enemy_count: int = 0:
	set(value):
		current_enemy_count = value
		if current_enemy_count == 0 and not is_enemy_spawning:
			await get_tree().create_timer(7.5).timeout
			wave += 1
var wave: int = 0:
	set(value):
		if wave != wave_count:
			wave = value
			Signals.emit_signal("wave_changed", wave)
			new_wave(wave)
		else:
			victory()



# Common functions
func _ready():
	# Scale
	# Square the scale to reach the best view
	menu_button.scale = Vector2(UserSettings.gui_scale**2, UserSettings.gui_scale**2)
	# Connect signals
	Signals.connect("target_died", Callable(self, "_on_target_died"))
	Signals.connect("health_changed", Callable(self, "_on_health_changed"))
	# Get data
	wave_count = data["wave_count"]
	PlayerStats.health = data["health"]
	PlayerStats.money = data["money"]
	PlayerStats.max_level = data["max_level"] # Max level is used in tower.tscn
	# Transition
	modulate = Color(0, 0, 0, 1)
	var tween_1 = create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
	var tween_2 = create_tween()
	tween_2.parallel().tween_property(SoundManager.music_idle, "volume_db", -20, 4.0)
	# Start the game
	state = States.IDLE

func idle_state(duration):
	SoundManager.music_idle.play()
	await get_tree().create_timer(duration).timeout
	fight_state()

func fight_state():
	# Getting ready
	SoundManager.music_fight.play()
	var tween_1 = create_tween()
	tween_1.parallel().tween_property(SoundManager.music_idle, "volume_db", -100, 4.0)
	tween_1.connect("finished", SoundManager.music_idle.stop)
	var tween_2 = create_tween()
	tween_2.parallel().tween_property(SoundManager.music_fight, "volume_db", -20, 4.0)
	await tween_2.finished
	# Fight
	wave += 1

func defeat():
	var defeat_menu = defeat_menu_scene.instantiate()
	user_interface.add_child(defeat_menu)
	menu_button.disabled = true

func victory():
	# Save
	UserData.level_data[name]["is_completed"] = true
	UserData.level_data[name]["stars"] = 3
	var file = FileAccess.open(UserData.SAVE_PATH, FileAccess.WRITE)
	file.store_var(UserData.level_data)
	var new_message = message_scene.instantiate()
	new_message.text = "Автосохранение..."
	user_interface.add_child(new_message)
	
	var victory_menu = victory_menu_scene.instantiate()
	user_interface.add_child(victory_menu)
	menu_button.disabled = true

func new_wave(number):
	# Declare the new wave
	var new_message = message_scene.instantiate()
	new_message.text = "Волна " + str(wave)
	user_interface.add_child(new_message)
	# Spawn enemies
	var enemy_count = data["wave_" + str(number)]["enemy_count"]
	var spawn_cooldown = data["wave_" + str(number)]["spawn_cooldown"]
	is_enemy_spawning = true
	for i in range(enemy_count):
		await get_tree().create_timer(spawn_cooldown).timeout
		var new_path_follow_2d = path_follow_2d_scene.instantiate()
		var new_ork = ork_scene.instantiate()
		new_path_follow_2d.add_child(new_ork)
		enemies.add_child(new_path_follow_2d)
		current_enemy_count += 1
	is_enemy_spawning = false

func _on_target_died(_body):
	current_enemy_count -= 1

func _on_health_changed(value):
	if value <= 0:
		defeat()



# Menu Button's functions
func _on_menu_button_pressed():
	SoundManager.click.play()
	if not menu.has_node("Game Menu"):
		var game_menu = game_menu_scene.instantiate()
		menu.add_child(game_menu)
	else:
		var game_menu = menu.get_node("Game Menu")
		game_menu.resume()
