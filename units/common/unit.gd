extends Node2D
class_name Unit



enum States {
	IDLE,
	ATTACK,
	COOLDOWN
}



@export var technical_name: StringName
@export var shell_scene: PackedScene



@onready var shell_container = get_tree().get_current_scene().get_node("Shell Container")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var find_timer = $"Find Timer"

@onready var attack_sfx = $SFX/Attack

@onready var default_view_direction = get_parent().get_parent().get_parent().default_view_direction

@onready var level: int

@onready var stats: Dictionary = UnitData.get(technical_name)["level_" + str(level)]
@onready var damage = stats["damage"]
@onready var attack_range = stats["attack_range"]
@onready var shell_speed = stats["shell_speed"]



var available_enemies: Array[Enemy] = []

var target: Enemy

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
					state = States.IDLE
			States.COOLDOWN:
				cooldown_state()
var current_view_direction: String



func _ready():
	state = States.IDLE
	collision_shape_2d.shape.radius = attack_range

func idle_state():
	current_view_direction = default_view_direction
	animation_player.play(str(current_view_direction, "_Idle"))

func attack_state():
	target = choose_target()
	current_view_direction = get_view_direction()
	animation_player.play(str(current_view_direction, "_Attack"))

func cooldown_state():
	animation_player.play(str(current_view_direction, "_Preattack"))
	await animation_player.animation_finished
	if available_enemies:
		state = States.ATTACK
	else:
		state = States.IDLE

# Animation Player
func shoot():
	# If the target hasn't run away or died yet
	if target in available_enemies:
		var new_shell = shell_scene.instantiate()
		new_shell.global_position = global_position + Vector2(0.0, -13.0)
		new_shell.damage = damage
		new_shell.speed = shell_speed
		new_shell.target = target
		shell_container.add_child(new_shell)
		attack_sfx.play()
		state = States.COOLDOWN
	else:
		state = States.IDLE

func _on_area_2d_body_entered(body):
	available_enemies.append(body)
	if state == States.IDLE:
		state = States.ATTACK

func _on_area_2d_body_exited(body):
	available_enemies.erase(body)
	# If target died or ran away and there are available enemies and not cooldown,
	# Choose a new target
	if target == body and available_enemies and state != States.COOLDOWN:
		attack_state()

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
	var preferred_target: Enemy = available_enemies[0]
	
	for enemy in available_enemies:
		# Choose the enemy closest to the Holy Oak
		var holy_oak = get_tree().get_current_scene().get_node("Objects/Holy Oak")
		if enemy.global_position.distance_to(holy_oak.global_position) < \
		preferred_target.global_position.distance_to(holy_oak.global_position):
			preferred_target = enemy
	
	return preferred_target
