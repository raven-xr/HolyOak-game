extends Node2D

enum States {
	IDLE,
	ATTACK,
	COOLDOWN
}

var targets = []
var target: CharacterBody2D
var is_looking_for_target = true
var state:
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
var arrow_preload = preload("res://units/archers/shell.tscn")

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var arrows = $Arrows
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var shot_2d = $SFX/Shot2D

@onready var default_direction = get_parent().get_parent().get_parent().get_parent().default_direction
@onready var default_flip_h = get_parent().get_parent().get_parent().get_parent().default_flip_h

@onready var attack_range = get_parent().get_parent().attack_range

func _ready():
	state = States.IDLE
	collision_shape_2d.shape.radius = attack_range

func idle_state():
	current_direction = default_direction
	animated_sprite_2d.flip_h = default_flip_h
	animation_player.play(str(current_direction, "_Idle"))

func attack_state():
	if is_looking_for_target:
		target = targets[0]
	current_direction = change_direction()[0]
	animated_sprite_2d.flip_h = change_direction()[1]
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
		var new_arrow = arrow_preload.instantiate()
		new_arrow.position = Vector2(0.0, -13.0)
		arrows.add_child(new_arrow)
		shot_2d.play()
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

func change_direction() -> Array:
	var angle_to_target = rad_to_deg(get_angle_to(target.global_position))
	if 45 < angle_to_target and angle_to_target <= 135:
		return ["D", false]
	elif 135 < angle_to_target or angle_to_target <= -135:
		return ["S", false]
	elif -135 < angle_to_target and angle_to_target <= -45:
		return ["U", false]
	else:
		return ["S", true]
