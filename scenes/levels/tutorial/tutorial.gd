extends Node2D

enum States {
	TUTORIAL,
	IDLE,
	FIGHT
}

var data = LevelData.tutorial
var wave_count = data["wave_count"]

var is_enemy_spawning = false
var state:
	set(value):
		state = value
		match state:
			States.TUTORIAL: tutorial_state()
			States.IDLE: idle_state(10.0)
			States.FIGHT: fight_state()
var current_enemy_count = 0:
	set(value):
		current_enemy_count = value
		if current_enemy_count == 0 and not is_enemy_spawning:
			await get_tree().create_timer(7.5).timeout
			wave += 1
var wave = 0:
	set(value):
		if wave != wave_count:
			wave = value
			Signals.emit_signal("wave_changed", wave)
			new_wave(wave)
		else:
			victory()

@export var hint_preload: PackedScene
@export var ork_preload: PackedScene
@export var message_preload: PackedScene
@export var defeat_menu_preload: PackedScene
@export var victory_menu_preload: PackedScene
@export var game_menu_preload: PackedScene
@export var next_level_path: String

@onready var enemies = $Enemies
@onready var towers = $Towers
@onready var user_interface = $UserInterface

@onready var trees = $Objects/Trees
@onready var bushes = $Objects/Bushes

@onready var menu = $UserInterface/Menu

@onready var platform_1 = $"Towers/Platform 1"

signal player_opened_platform()
signal player_built_tower()
signal player_upgraded_tower()
signal player_checked_stats()
@warning_ignore("unused_signal")
signal player_ended_tutorial()

func _ready():
	# Connect signals
	Signals.connect("target_died", Callable(self, "_on_target_died"))
	Signals.connect("health_changed", Callable(self, "_on_health_changed"))
	# Update PlayerStats
	PlayerStats.health = data["health"]
	PlayerStats.money = data["money"]
	PlayerStats.max_level = data["max_level"]
	# Transition
	modulate = Color(0, 0, 0, 1)
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(SoundManager.music_idle, "volume_db", -20, 4.0)
	for tree in trees.get_children():
		var size = randf_range(1.4, 1.6)
		tree.scale = Vector2(size, size)
	for bush in bushes.get_children():
		var size = randf_range(0.8, 1.1)
		bush.scale = Vector2(size, size)
	# Start the game
	state = States.TUTORIAL

func tutorial_state():
	# Turn the music on
	SoundManager.music_idle.play()
	
	# Greeting
	for _hint in Hints.tutorial["greeting"]:
		var _new_hint = hint_preload.instantiate()
		_new_hint.text = _hint["text"]
		_new_hint.position = _hint["position"]
		add_child.call_deferred(_new_hint)
		# Wait for player to close hints
		await _new_hint.tree_exited
	
	# Declare vars
	var hint
	var new_hint
	
	# Open the platform menu
	hint = Hints.tutorial["first_tower"][0]
	new_hint = hint_preload.instantiate()
	new_hint.text = hint["text"]
	new_hint.position = hint["position"]
	new_hint.can_be_closed = false
	user_interface.add_child(new_hint)
	# Unblock the platform 1
	platform_1.set_process_mode(Node.PROCESS_MODE_INHERIT)
	# Wait for player to open the platform menu
	await player_opened_platform
	new_hint.close()
	await new_hint.tree_exited
	
	# Build the tower
	hint = Hints.tutorial["first_tower"][1]
	new_hint = hint_preload.instantiate()
	new_hint.text = hint["text"]
	new_hint.position = hint["position"]
	new_hint.can_be_closed = false
	user_interface.add_child(new_hint)
	# Wait for player to build the tower
	await player_built_tower
	new_hint.close()
	await new_hint.tree_exited
	
	# Upgrade the tower
	hint = Hints.tutorial["first_tower"][2]
	new_hint = hint_preload.instantiate()
	new_hint.text = hint["text"]
	new_hint.position = hint["position"]
	new_hint.can_be_closed = false
	user_interface.add_child(new_hint)
	# Wait for player to upgrade the tower
	await player_upgraded_tower
	new_hint.close()
	await new_hint.tree_exited
	
	# Check current stats
	hint = Hints.tutorial["first_tower"][3]
	new_hint = hint_preload.instantiate()
	new_hint.text = hint["text"]
	new_hint.position = hint["position"]
	new_hint.can_be_closed = false
	user_interface.add_child(new_hint)
	# Unblock the TowerStats button
	platform_1.tower_stats_button.disconnect("mouse_entered", Callable(platform_1, "_on_tower_stats_button_mouse_entered"))
	# Wait for player to check current stats
	await player_checked_stats
	new_hint.close()
	await new_hint.tree_exited
	
	# Talk about removing towers
	hint = Hints.tutorial["first_tower"][4]
	new_hint = hint_preload.instantiate()
	new_hint.text = hint["text"]
	new_hint.position = hint["position"]
	user_interface.add_child(new_hint)
	# Wait for player to close the hint
	await new_hint.tree_exited
	
	# Goodbye
	hint = Hints.tutorial["goodbye"][0]
	new_hint = hint_preload.instantiate()
	new_hint.text = hint["text"]
	new_hint.position = hint["position"]
	user_interface.add_child(new_hint)
	# Wait for player to close the hint
	await new_hint.tree_exited
	
	# End the tutorial
	emit_signal("player_ended_tutorial")
	for platform in towers.get_children():
		platform.set_process_mode(Node.PROCESS_MODE_INHERIT)
	state = States.FIGHT

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
	var defeat_menu = defeat_menu_preload.instantiate()
	user_interface.add_child(defeat_menu)

func victory():
	UserData.level_data[name]["is_completed"] = true
	UserData.level_data[name]["stars"] = 3
	var victory_menu = victory_menu_preload.instantiate()
	user_interface.add_child(victory_menu)

func new_wave(number):
	# Declare the new wave
	var new_message = message_preload.instantiate()
	new_message.text = "Волна " + str(wave)
	user_interface.add_child(new_message)
	# Spawn enemies
	var enemy_count = data[str("wave_", number)]["enemy_count"]
	var spawn_cooldown = data[str("wave_", number)]["spawn_cooldown"]
	is_enemy_spawning = true
	for i in range(enemy_count):
		await get_tree().create_timer(spawn_cooldown).timeout
		var new_ork = ork_preload.instantiate()
		enemies.add_child(new_ork)
		current_enemy_count += 1
	is_enemy_spawning = false

func _on_target_died(_body):
	current_enemy_count -= 1

func _on_health_changed(value):
	if value <= 0:
		defeat()

func _on_menu_button_pressed():
	SoundManager.click.play()
	if not menu.has_node("GameMenu"):
		var game_menu = game_menu_preload.instantiate()
		menu.add_child(game_menu)
	else:
		var game_menu = menu.get_node("GameMenu")
		game_menu.resume()
