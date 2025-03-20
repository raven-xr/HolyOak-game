extends Node2D
class_name Unit

enum States {
	IDLE,
	ATTACK,
	COOLDOWN
}

@export var technical_name: StringName
@export var shell_scene: PackedScene

@onready var shell_container: Node2D = get_tree().get_current_scene().get_node("Shell Container")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var find_timer: Timer = $"Find Timer"
@onready var attack_sfx: AudioStreamPlayer2D = $SFX/Attack

@onready var default_view_direction: String = get_parent().get_parent().get_parent().default_view_direction

@onready var stats: Dictionary = UnitData.get(technical_name)["level_" + str(level)]
@onready var damage = stats["damage"]
@onready var attack_range = stats["attack_range"]
@onready var shell_speed = stats["shell_speed"]

var available_enemies: Array[Enemy] = []
var target: Enemy
##TODO: TEST
## The units use this variable to determine if the target previously died after it was chosen as the best
var is_target_known_previously_died: bool
## The units use this variable to determine if the target is still available after it was chosen as the best
var is_target_still_available: bool = true
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
	target = choose_target()
	is_target_still_available = true
	if target.is_previously_died():
		is_target_known_previously_died = true
	else:
		is_target_known_previously_died = false
	current_view_direction = get_view_direction()
	animation_player.play(current_view_direction + "_Attack")

func cooldown_state() -> void:
	animation_player.play(current_view_direction + "_Preattack")
	await animation_player.animation_finished
	if available_enemies:
		state = States.ATTACK
	else:
		state = States.IDLE

# Animation Player
func shoot() -> void:
	# If the target died/left the attack range and if there are no other available enemies.
	if not is_target_still_available and not available_enemies:
		# then make the unit cooldowning
		state = States.COOLDOWN
	else:
		# If the target died/left the attack range and if there are other available enemies,
		if not is_target_still_available and available_enemies \
		# or if the target just previously died, but it was OK when archer chose it,
		# and if there are other available enemies,
		or not is_target_known_previously_died and target.is_previously_died() and len(available_enemies) > 1:
		# then choose another one
			animation_player.stop() # Reset the animation
			attack_state()
		# Shot
		var new_shell = shell_scene.instantiate()
		new_shell.global_position = global_position + Vector2(0.0, -13.0)
		new_shell.damage = damage
		new_shell.speed = shell_speed
		new_shell.target = target
		shell_container.add_child(new_shell)
		attack_sfx.play()
		state = States.COOLDOWN

func _on_area_2d_body_entered(body: Enemy) -> void:
	available_enemies.append(body)
	if state == States.IDLE:
		state = States.ATTACK

func _on_area_2d_body_exited(body: Enemy) -> void:
	available_enemies.erase(body)
	is_target_still_available = false

func choose_target() -> Enemy:
	var preferred_target: Enemy = available_enemies[0]
	var preferred_enemies: Array[Enemy] = []
	var dying_enemies: Array[Enemy] = get_going_to_die_enemies()
	var alive_enemies: Array[Enemy] = get_alive_enemies()
	# If there are alive enemies, choose the best target from them
	if alive_enemies:
		preferred_enemies = alive_enemies.duplicate()
	# Else, choose the best target from the dying enemies
	else:
		preferred_enemies = dying_enemies.duplicate()
	for enemy in preferred_enemies:
		# Choose the enemy closest to the Holy Oak
		var holy_oak = get_tree().get_current_scene().get_node("Map/Holy Oak")
		if enemy.global_position.distance_to(holy_oak.global_position) < \
		preferred_target.global_position.distance_to(holy_oak.global_position):
			preferred_target = enemy
	return preferred_target

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

func get_going_to_die_enemies() -> Array[Enemy]:
	var dying_enemies: Array[Enemy] = []
	for enemy in available_enemies:
		if enemy.is_previously_died():
			dying_enemies.append(enemy)
	return dying_enemies

func get_alive_enemies() -> Array[Enemy]:
	var alive_enemies: Array[Enemy] = []
	for enemy in available_enemies:
		if not enemy.is_previously_died():
			alive_enemies.append(enemy)
	return alive_enemies
