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
@export var next_level: StringName = "main_menu"

@export var technical_name: StringName

@onready var towers: Node2D = $Towers
@onready var gui: Control = $GUI
@onready var menu_button: Button = $GUI/MenuButton
@onready var wave_timer: Timer = $"Timers/Wave Timer"
@onready var spawn_timer: Timer = $"Timers/Spawn Timer"

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
	gui.add_child(defeat_menu)
	menu_button.disabled = true

func victory() -> void:
	# Save
	UserData.progress[technical_name]["is_completed"] = true
	UserData.progress[technical_name]["stars"] = 3
	var save = FileAccess.open(UserData.SAVE_PATH, FileAccess.WRITE)
	save.store_var(UserData.progress)
	Global.game_controller.change_gui_scene("message")
	Global.game_controller.current_gui_scene.set_text("Автосохранение...")
	
	var victory_menu = victory_menu_scene.instantiate()
	gui.add_child(victory_menu)
	menu_button.disabled = true

func new_wave() -> void:
	# Declare the new wave
	Global.game_controller.change_gui_scene("message")
	Global.game_controller.current_gui_scene.set_text("Волна " + str(wave))
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
	if not gui.has_node("GameMenu"):
		var game_menu = game_menu_scene.instantiate()
		gui.add_child(game_menu)
	else:
		var game_menu = gui.get_node("GameMenu")
		game_menu.resume()

func _on_start_timer_timeout() -> void:
	state = States.FIGHT

func _on_wave_timer_timeout() -> void:
	wave += 1

# -------------------------------------------------------------------------------- #
# ----------------------------------GUI------------------------------------------- #

func _on_tower_menu_opened(tower_menu: Control) -> void:
	# If any tower menu was opened, disable the other ones
	for tower in towers.get_children():
		# If the opened tower menu is the tower menu of the tower of the current iteration,
		# leave its TouchScreenButton enabled
		if tower.tower_menu == tower_menu:
			continue
		tower.touch_screen_button.visible = false

func _on_tower_menu_closed(tower_menu: Control) -> void:
	# Do not turn the TowerMenu on if a TowerStats has just been opened
	if gui.has_node("TowerStats"):
		return
	# If the tower menu was closed, enable the other ones
	for tower in towers.get_children():
		# If the opened tower menu is the tower menu of the tower of the current iteration
		# or the tower is upgrading, leave its TouchScreenButton disabled/enabled
		# (depends on whether you started building/upgrading it now)
		if tower.tower_menu == tower_menu or tower.is_upgrading:
			continue
		tower.touch_screen_button.visible = true

func _on_tower_stats_opened() -> void:
	for tower in towers.get_children():
		tower.touch_screen_button.visible = false

func _on_tower_stats_closed() -> void:
	for tower in towers.get_children():
		if tower.is_upgrading:
			continue
		tower.touch_screen_button.visible = true
