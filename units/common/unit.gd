extends Node2D
class_name Unit



enum States {
	IDLE,
	ATTACK,
	COOLDOWN
}



@export var technical_name: StringName
@export var shell_scene: PackedScene



@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var shells = $Shells

@onready var attack_sfx = $SFX/Attack

@onready var default_direction = get_parent().get_parent().get_parent().default_direction

@onready var level: int
@onready var stats: Dictionary = UnitData.get(technical_name)["level_" + str(level)]
@onready var damage = stats["damage"]
@onready var attack_range = stats["attack_range"]
@onready var shell_speed = stats["shell_speed"]



var targets: Array = []
var target: Enemy
var is_looking_for_target: bool = true
var state: int:
	set(value):
		state = value
		match state:
			States.IDLE: 
				idle_state()
			States.ATTACK: 
				attack_state()
			States.COOLDOWN:
				cooldown_state()
var current_direction: String



func _ready():
	state = States.IDLE
	collision_shape_2d.shape.radius = attack_range

func idle_state():
	current_direction = default_direction
	animation_player.play(str(current_direction, "_Idle"))

func attack_state():
	if is_looking_for_target:
		target = targets[0]
	current_direction = get_direction()
	animation_player.play(str(current_direction, "_Attack"))

func cooldown_state():
	animation_player.play(str(current_direction, "_Preattack"))
	await animation_player.animation_finished
	if len(targets) > 0:
		state = States.ATTACK
	else:
		state = States.IDLE

func shoot():
	if len(targets) > 0:
		var new_shell = shell_scene.instantiate()
		new_shell.position = Vector2(0.0, -13.0)
		new_shell.damage = damage
		new_shell.speed = shell_speed
		new_shell.target = target
		shells.add_child(new_shell)
		attack_sfx.play()
	state = States.COOLDOWN

func _on_area_2d_body_entered(body):
	targets.append(body)
	if state != States.COOLDOWN:
		state = States.ATTACK

func _on_area_2d_body_exited(body):
	targets.erase(body)
	if target == body:
		is_looking_for_target = true
		if len(targets) > 0:
			state = States.ATTACK

func get_direction() -> String:
	var angle_to_target = rad_to_deg(get_angle_to(target.global_position))
	if -135 < angle_to_target and angle_to_target <= -45:
		return "U"
	elif -135 < angle_to_target and angle_to_target <= 45:
		return "R"
	elif 45 < angle_to_target and angle_to_target <= 135:
		return "D"
	else:
		return "L"
