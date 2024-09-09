extends Node2D

enum States {
	IDLE,
	FIGHT
}

var data = LevelData.tutorial
var wave_count = data['wave_count']

var is_enemy_spawning = false
var state:
	set(value):
		state = value
		match state:
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
		wave = value
		Signals.emit_signal("wave_change", wave)
		new_wave(wave)
var ork_preload = preload("res://enemies/ork/enemy.tscn")
var message_preload = preload("res://subscenes/message/message.tscn")

@onready var radio_idle = $SFX/RadioIdle
@onready var radio_fight = $SFX/RadioFight
@onready var enemies = $Enemies
@onready var trees = $Objects/Trees
@onready var bushes = $Objects/Bushes
@onready var user_interface = $UserInterface

func _ready():
	# Connect signals
	Signals.connect("target_die", Callable(self, "_on_target_die"))
	# Update PlayerStats
	PlayerStats.health = data['health']
	PlayerStats.money = data['money']
	PlayerStats.max_level = data['max_level']
	# Getting ready
	modulate = Color(0, 0, 0, 1)
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(radio_idle, "volume_db", -20, 4.0)
	for tree in trees.get_children():
		var size = randf_range(1.4, 1.6)
		tree.scale = Vector2(size, size)
	for bush in bushes.get_children():
		var size = randf_range(0.8, 1.1)
		bush.scale = Vector2(size, size)
	# Start the game
	state = States.IDLE

func idle_state(duration):
	radio_idle.play()
	await get_tree().create_timer(duration).timeout
	state = States.FIGHT

func fight_state():
	# Getting ready
	radio_fight.play()
	var tween_1 = get_tree().create_tween()
	tween_1.parallel().tween_property(radio_idle, "volume_db", -100, 4.0)
	tween_1.connect("finished", radio_idle.stop)
	var tween_2 = get_tree().create_tween()
	tween_2.parallel().tween_property(radio_fight, "volume_db", -20, 4.0)
	await tween_2.finished
	# Fight
	if wave != wave_count:
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

func _on_target_die(_body):
	current_enemy_count -= 1
