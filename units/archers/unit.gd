extends Node2D

enum {
	IDLE,
	ATTACK,
	COOLDOWN
}

var targets = []
var target
var is_looking_for_target = true
var state:
	set(value):
		state = value
		match state:
			IDLE: 
				idle_state()
			ATTACK: 
				attack_state()
			COOLDOWN:
				cooldown_state()
var current_direction
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
	state = IDLE
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
		state = ATTACK
	else:
		state = IDLE

func shoot():
	if len(targets) > 0:
		var new_arrow = arrow_preload.instantiate()
		new_arrow.position = Vector2(0.0, -13.0)
		arrows.add_child(new_arrow)
		shot_2d.play()
	state = COOLDOWN

func _on_area_2d_body_entered(body):
	targets.append(body)
	if state != COOLDOWN:
		state = ATTACK

func _on_area_2d_body_exited(body):
	targets.erase(body)
	if target == body:
		is_looking_for_target = true
		if len(targets) > 0:
			state = ATTACK

func change_direction() -> Array:
	var angle_to_target = rad_to_deg(get_angle_to(target.position))
	if 45 < angle_to_target and angle_to_target <= 135:
		return ["D", false]
	elif 135 < angle_to_target or angle_to_target <= -135:
		return ["S", false]
	elif -135 < angle_to_target and angle_to_target <= -45:
		return ["U", false]
	else:
		return ["S", true]
