extends Node2D

enum States {
	IDLE,
	FIGHT
}

var data = LevelData.tutorial
var wave_count = data['wave_count']
var next_level_path = "res://scenes/main_menu/main_menu.tscn" # !!!

var is_enemy_spawning = false
var state:
	set(value):
		state = value
		match state:
			States.IDLE: idle_state()
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

var ork_preload = preload("res://enemies/ork/enemy.tscn")
var message_preload = preload("res://common/message/message.tscn")
var defeat_menu_preload = preload("res://common/defeat_menu/defeat_menu.tscn")
var victory_menu_preload = preload("res://common/victory_menu/victory_menu.tscn")
var game_menu_preload = preload("res://common/game_menu/game_menu.tscn")

@onready var enemies = $Enemies
@onready var trees = $Objects/Trees
@onready var bushes = $Objects/Bushes
@onready var user_interface = $UserInterface
@onready var menu_button = $UserInterface/MenuButton

func _ready():
	# Connect signals
	Signals.connect("target_died", Callable(self, "_on_target_died"))
	Signals.connect("health_changed", Callable(self, "_on_health_changed"))
	# Update PlayerStats
	PlayerStats.health = data['health']
	PlayerStats.money = data['money']
	PlayerStats.max_level = data['max_level']
	# Getting ready
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
	state = States.IDLE

func idle_state():
	SoundManager.music_idle.play()

func fight_state():
	# Getting ready
	SoundManager.music_fight.play()
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(SoundManager.music_idle, "volume_db", -100, 4.0)
	tween_1.connect("finished", SoundManager.music_idle.stop)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(SoundManager.music_fight, "volume_db", -20, 4.0)
	await tween_2.finished
	# Fight
	wave += 1
	var new_message = message_preload.instantiate()
	new_message.text = str('Wave ', wave)
	user_interface.add_child(new_message)

func new_wave(number):
	var enemy_count = data[str('wave_', number)]['enemy_count']
	var spawn_cooldown = data[str('wave_', number)]['spawn_cooldown']
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

func defeat():
	var defeat_menu = defeat_menu_preload.instantiate()
	user_interface.add_child(defeat_menu)

func victory():
	var victory_menu = victory_menu_preload.instantiate()
	user_interface.add_child(victory_menu)

func _on_menu_button_pressed():
	SoundManager.click.play()
	if menu_button.get_child_count() == 0:
		var game_menu = game_menu_preload.instantiate()
		menu_button.add_child(game_menu)
	else:
		var game_menu = menu_button.get_child(0)
		game_menu._on_resume_button_pressed()
