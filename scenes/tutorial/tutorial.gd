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

@export var hint_scene: PackedScene
@export var ork_scene: PackedScene
@export var message_scene: PackedScene
@export var defeat_menu_scene: PackedScene
@export var victory_menu_scene: PackedScene
@export var game_menu_scene: PackedScene
@export var next_level_path: String

@onready var enemies = $Enemies
@onready var towers = $Towers
@onready var user_interface = $UserInterface

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
	PlayerStats.max_level = data["max_level"] # Max level is used in tower.tscn
	# Transition
	modulate = Color(0, 0, 0, 1)
	var tween_1 = create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
	var tween_2 = create_tween()
	tween_2.parallel().tween_property(SoundManager.music_idle, "volume_db", -20, 4.0)
	# Start the game
	state = States.TUTORIAL

func tutorial_state():
	## Get ready
	SoundManager.music_idle.play()
	var hint = hint_scene.instantiate()
	user_interface.add_child(hint)
	## Greet
	hint.text = "Здравствуй, вождь. Добро пожаловать в Holy Oak!"
	hint.position = Vector2(576.0, 320.0)
	hint.show_()
	await hint.hidden_
	# Await for player to close the hint
	hint.text = "В этой игре ваша главная задача - защитить Священный дуб"
	hint.show_()
	# Await for player to close the hint
	await hint.hidden_
	
	## Open the platform menu
	hint.text = "Для начала построим башню. Нажмите на пустое поле слева"
	hint.position = Vector2(1024.0, 128.0)
	hint.can_be_pressed = false
	hint.show_()
	# Unblock the platform 1
	platform_1.set_process_mode(Node.PROCESS_MODE_INHERIT)
	# Await for player to open the platform menu
	await player_opened_platform
	hint.hide_()
	await hint.hidden_
	
	## Build the tower
	hint.text = "Теперь нажмите 'Build', чтобы её построить"
	hint.show_()
	# Await for player to build the tower
	await player_built_tower
	hint.hide_()
	await hint.hidden_
	
	## Upgrade the tower
	hint.text = "Чтобы повысить эффективность защиты, необходимо улучшить башню. Откройте меню и нажмите 'Upgrade'"
	hint.show_()
	# Await for player to upgrade the tower
	await player_upgraded_tower
	hint.hide_()
	await hint.hidden_
	
	## Check current stats
	hint.text = "Отлично. Нажми на кнопку 'Stats', чтобы посмотреть текущие характеристики башни и юнитов"
	hint.show_()
	# Unblock the TowerStats button
	platform_1.tower_stats_button.disconnect("mouse_entered", Callable(platform_1, "_on_local_tower_stats_button_mouse_entered"))
	# Await for player to check current stats
	await player_checked_stats
	hint.hide_()
	await hint.hidden_
	
	## Tell about removing towers
	hint.text = "Запомни, что в случае, если нужно построить башню в другом месте, а у тебя не хватает денег, ты всегда можешь избавиться от другой, нажав 'Remove' и получив обратно 50% от стоимости (уничтожать эту башню не нужно)"
	hint.can_be_pressed = true
	hint.show_()
	# Await for player to close the hint
	await hint.hidden_
	
	## Say goodbye
	hint.text = "О, нет! Вы это слышите? Враг надвигается!.. Всё в ваших руках, вождь!"
	hint.position = Vector2(576.0, 320.0)
	hint.show_()
	# Await for player to close the hint
	await hint.hidden_
	
	## End the tutorial
	hint.close()
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
	var defeat_menu = defeat_menu_scene.instantiate()
	user_interface.add_child(defeat_menu)

func victory():
	var victory_menu = victory_menu_scene.instantiate()
	user_interface.add_child(victory_menu)
	# Save
	UserData.level_data[name]["is_completed"] = true
	UserData.level_data[name]["stars"] = 3
	var file = FileAccess.open(UserData.SAVE_PATH, FileAccess.WRITE)
	file.store_var(UserData.level_data)
	var new_message = message_scene.instantiate()
	new_message.text = "Автосохранение..."
	user_interface.add_child(new_message)

func new_wave(number):
	# Declare the new wave
	var new_message = message_scene.instantiate()
	new_message.text = "Волна " + str(wave)
	user_interface.add_child(new_message)
	# Spawn enemies
	var enemy_count = data[str("wave_", number)]["enemy_count"]
	var spawn_cooldown = data[str("wave_", number)]["spawn_cooldown"]
	is_enemy_spawning = true
	for i in range(enemy_count):
		await get_tree().create_timer(spawn_cooldown).timeout
		var new_ork = ork_scene.instantiate()
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
		var game_menu = game_menu_scene.instantiate()
		menu.add_child(game_menu)
	else:
		var game_menu = menu.get_node("GameMenu")
		game_menu.resume()
