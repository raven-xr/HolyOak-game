extends Node2D
class_name Level

enum States {
	TUTORIAL,
	IDLE,
	FIGHT
}

@export var ork_scene: PackedScene
@export var slime_scene: PackedScene

@export var hint_scene: PackedScene
@export var message_scene: PackedScene

@export var defeat_menu_scene: PackedScene
@export var victory_menu_scene: PackedScene
@export var game_menu_scene: PackedScene

## Leave this field if there are no levels left
@export var next_level_path: String = "res://gamedata/scene/main_menu/main_menu.tscn"
@export var technical_name: StringName
@onready var user_interface = $"User Interface"
@onready var menu_button = $"User Interface/Menu Button"
@onready var wave_timer = $"Timers/Wave Timer"
@onready var spawn_timer = $"Timers/Spawn Timer"

@onready var data: Dictionary = LevelData.get(technical_name)

var wave_count: int = 0
var wave: int = 0:
	set(value):
		wave = value
		if wave <= wave_count:
			Signals.wave_changed.emit(wave)
			new_wave()
		else:
			victory()
## If there are no enemies left, the game checks if enemies are still spawning. 
## If true, it starts a new wave, else keep waiting
var is_enemies_spawning: bool = false
var current_enemy_count: int = 0:
	set(value):
		current_enemy_count = value
		if current_enemy_count == 0 and not is_enemies_spawning:
			wave_timer.start()
var state: int:
	set(value):
		state = value
		match state:
			States.IDLE: idle_state()
			States.FIGHT: fight_state()

func _ready() -> void:
	# Scale
	# Square the scale to reach the best view
	menu_button.scale = Vector2(UserSettings.gui_scale**2, UserSettings.gui_scale**2)
	# Connect signals
	Signals.connect("health_changed", Callable(self, "_on_health_changed"))
	# Get data
	wave_count = data["wave_count"]
	PlayerStats.health = data["health"]
	PlayerStats.money = data["money"]
	PlayerStats.tower_level_limit = data["tower_level_limit"] # Used in tower.tscn
	# Transition
	modulate = Color(0, 0, 0, 1)
	var tween_1 = create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
	var tween_2 = create_tween()
	tween_2.parallel().tween_property(SoundManager.music_idle, "volume_db", -20, 4.0)
	# Start the game
	state = States.IDLE

func idle_state() -> void:
	# P.S. Start Timer autostarts
	SoundManager.music_idle.play()

func fight_state() -> void:
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

func defeat() -> void:
	var defeat_menu = defeat_menu_scene.instantiate()
	user_interface.add_child(defeat_menu)
	menu_button.disabled = true

func victory() -> void:
	# Save
	UserData.progress[name]["is_completed"] = true
	UserData.progress[name]["stars"] = 3
	var save = FileAccess.open(UserData.SAVE_PATH, FileAccess.WRITE)
	save.store_var(UserData.progress)
	var new_message = message_scene.instantiate()
	new_message.text = "Автосохранение..."
	user_interface.add_child(new_message)
	
	var victory_menu = victory_menu_scene.instantiate()
	user_interface.add_child(victory_menu)
	menu_button.disabled = true

func new_wave() -> void:
	# Declare the new wave
	var new_message = message_scene.instantiate()
	new_message.text = "Волна " + str(wave)
	user_interface.add_child(new_message)
	# Spawn enemies
	var spawn_cooldown: float = data["wave_" + str(wave)]["spawn_cooldown"]
	var enemies: Array = data["wave_" + str(wave)]["enemies"]
	
	is_enemies_spawning = true
	
	for enemy in enemies:
		var new_enemy = get(enemy["type"] + "_scene").instantiate()
		var road = get_node("Enemies/Road " + enemy["road"])
		# Wait for the spawn cooldown
		spawn_timer.wait_time = spawn_cooldown
		spawn_timer.start()
		await spawn_timer.timeout
		# Place a new enemy at the 1st roadpoint
		new_enemy.next_roadpoint_position = road.get_node("Waypoints").get_node("Waypoint 1").position
		new_enemy.position = road.get_node("Waypoints").get_node("Waypoint 1").position
		new_enemy.connect("died", Callable(self, "_on_enemy_died"))
		road.add_child(new_enemy)
		current_enemy_count += 1
	
	is_enemies_spawning = false

func _on_enemy_died() -> void:
	current_enemy_count -= 1

func _on_health_changed(value: int) -> void:
	if value <= 0:
		defeat()

func _on_menu_button_pressed() -> void:
	SoundManager.click.play()
	if not user_interface.has_node("Game Menu"):
		var game_menu = game_menu_scene.instantiate()
		user_interface.add_child(game_menu)
	else:
		var game_menu = user_interface.get_node("Game Menu")
		game_menu.resume()

func _on_start_timer_timeout() -> void:
	state = States.FIGHT

func _on_wave_timer_timeout() -> void:
	wave += 1
