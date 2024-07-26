extends Node2D

enum {
	IDLE,
	ATTACK,
	COOLDOWN
}

var enemies = []
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
var current_view_direction

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var arrows = $Arrows
@onready var arrow_preload = preload("res://scenes/units/archers/arrow.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D

@onready var default_view_direction = get_parent().get_parent().get_parent().get_parent().default_view_direction
@onready var default_flip_h = get_parent().get_parent().get_parent().get_parent().default_flip_h

@onready var attack_range = get_parent().get_parent().attack_range

func _ready():
	state = IDLE
	collision_shape_2d.shape.radius = attack_range

func idle_state():
	current_view_direction = default_view_direction
	animated_sprite_2d.flip_h = default_flip_h
	animation_player.play(str(current_view_direction, "_Idle"))

func attack_state():
	current_view_direction = change_view_direction()[0]
	animated_sprite_2d.flip_h = change_view_direction()[1]
	animation_player.play(str(current_view_direction, "_Attack"))

func cooldown_state():
	animation_player.play(str(current_view_direction, "_Preattack"))
	await animation_player.animation_finished
	if len(enemies) >= 1:
		state = ATTACK
	else:
		state = IDLE

func shoot():
	if len(enemies) >= 1:
		var arrow = arrow_preload.instantiate()
		arrow.position = Vector2(0.0, -13.0)
		arrows.add_child(arrow)
	state = COOLDOWN

func _on_area_2d_body_entered(body):
	enemies.append(body)
	state = ATTACK

func _on_area_2d_body_exited(body):
	enemies.erase(body)

func change_view_direction() -> Array:
	var angle_to_enemy = rad_to_deg(get_angle_to(enemies[0].position))
	if 45 < angle_to_enemy and angle_to_enemy <= 135:
		return ["D", false]
	elif 135 < angle_to_enemy or angle_to_enemy <= -135:
		return ["S", false]
	elif -135 < angle_to_enemy and angle_to_enemy <= -45:
		return ["U", false]
	else:
		animated_sprite_2d.flip_h = true
		return ["S", true]
