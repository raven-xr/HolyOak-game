extends Node2D
class_name Unit

enum States {
	IDLE,
	ATTACK,
	COOLDOWN
}

@export var technical_name: StringName

@export var logo: Texture
@export var shell_scene: PackedScene

@onready var shell_container: Node2D = get_tree().get_current_scene().get_node("Shell Container")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var find_timer: Timer = $"Find Timer"
@onready var attack_sfx: AudioStreamPlayer2D = $SFX/Attack

@onready var default_view_direction: StringName = get_parent().get_parent().default_view_direction

@onready var stats: Dictionary[StringName, Dictionary] = UnitData.get(technical_name)
@onready var damage: int = stats["level_" + str(level)]["damage"]
@onready var attack_range: int = stats["level_" + str(level)]["attack_range"]
@onready var shell_speed: int = stats["level_" + str(level)]["shell_speed"]

var available_enemies: Array[Enemy] = []
var target: Enemy
var level: int = 0
var state: int:
	set(value):
		state = value
		match state:
			States.IDLE: 
				idle_state()
			States.ATTACK:
				# Give the unit some time to find all available enemies
				find_timer.start()
				await find_timer.timeout
				# If there are still available enemies
				if available_enemies:
					attack_state()
				else:
					idle_state()
					state = States.IDLE
			States.COOLDOWN:
				cooldown_state()
var current_view_direction: String

func _ready() -> void:
	state = States.IDLE
	collision_shape_2d.shape.radius = attack_range

func idle_state() -> void:
	current_view_direction = default_view_direction
	animation_player.play(current_view_direction + "_Idle")

func attack_state() -> void:
	# If the unit doesn't have a target, choose it
	if target == null:
		target = choose_target()
		# Connect the signal if it's not connected yet
		if not target.is_connected("died", Callable(self, "_on_target_died")):
			target.connect("died", Callable(self, "_on_target_died"))
	current_view_direction = get_view_direction()
	animation_player.play(current_view_direction + "_Attack")

func cooldown_state() -> void:
	animation_player.play(current_view_direction + "_Preattack")
	await animation_player.animation_finished
	if available_enemies:
		state = States.ATTACK
	else:
		state = States.IDLE

func shoot() -> void:
	# If there are available enemies (it means that target may be still available)
	if available_enemies:
		if target == null:
			# If the target has dead/ran away, choose another one
			target = choose_target()
			# Ain't forgetting to change the view direction
			current_view_direction = get_view_direction()
		# Shot
		var new_shell = shell_scene.instantiate()
		new_shell.global_position = global_position + Vector2(0.0, -13.0)
		new_shell.damage = damage
		new_shell.speed = shell_speed
		new_shell.target = target
		new_shell.target_global_position = target.global_position
		shell_container.add_child(new_shell)
		attack_sfx.play()
	# Anyway, cooldown
	state = States.COOLDOWN

func _on_area_2d_body_entered(body: Enemy) -> void:
	available_enemies.append(body)
	if state == States.IDLE:
		state = States.ATTACK

func _on_area_2d_body_exited(body: Enemy) -> void:
	available_enemies.erase(body)
	if body == target:
		target = null

func get_view_direction() -> String:
	var angle_to_target = get_angle_to(target.global_position)
	if angle_to_target < 0: angle_to_target += TAU
	if PI/4 < angle_to_target and angle_to_target <= 3*PI/4:
		return "D"
	elif 3*PI/4 < angle_to_target and angle_to_target <= 5*PI/4:
		return "L"
	elif 5*PI/4 < angle_to_target and angle_to_target <= 7*PI/4:
		return "U"
	else:
		return "R"

func choose_target() -> Enemy:
	var preferred_target: Enemy
	var previously_died_enemies: Array[Enemy] = get_previously_died_enemies()
	var alive_enemies: Array[Enemy] = get_alive_enemies()
	var preferred_enemies: Array[Enemy]
	# If there are alive enemies, choose some of them
	if alive_enemies:
		preferred_enemies = alive_enemies
	else:
		preferred_enemies = previously_died_enemies
	# Find the target closest to the Holy Oak
	preferred_target = preferred_enemies[0]
	for enemy in preferred_enemies:
		var holy_oak = get_tree().get_current_scene().get_node("Map/Holy Oak")
		if enemy.global_position.distance_to(holy_oak.global_position) < \
		preferred_target.global_position.distance_to(holy_oak.global_position):
			preferred_target = enemy
	return preferred_target

func get_alive_enemies() -> Array[Enemy]:
	var alive_enemies: Array[Enemy] = []
	for enemy in available_enemies:
		if not enemy.is_previously_died:
			alive_enemies.append(enemy)
	return alive_enemies

func get_previously_died_enemies() -> Array[Enemy]:
	var previously_died_enemies: Array[Enemy] = []
	for enemy in available_enemies:
		if enemy.is_previously_died:
			previously_died_enemies.append(enemy)
	return previously_died_enemies

func _on_target_died() -> void:
	target = null
