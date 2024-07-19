extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var arrows = $Arrows
@onready var arrow_preload = preload("res://scenes/units/archers/arrow.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D

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
@onready var default_view_direction # The value is given by the tower
@onready var flip_h: bool # The value is given by the tower
var current_view_direction

func _ready():
	state = IDLE

func idle_state():
	current_view_direction = default_view_direction
	animation_player.play(str(current_view_direction, "_Idle"))
	animated_sprite_2d.flip_h = flip_h

func attack_state():
	change_view_direction()
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
		arrow.enemy = enemies[0]
		arrow.position = Vector2(0.0, -24.0)
		arrows.add_child(arrow)
	state = COOLDOWN

func _on_area_2d_body_entered(body):
	state = ATTACK
	enemies.append(body)

func _on_area_2d_body_exited(body):
	enemies.erase(body)

func change_view_direction():
	if len(enemies) >= 1:
		var angle_to_enemy = rad_to_deg(get_angle_to(enemies[0].position))
		if 45 < angle_to_enemy and angle_to_enemy <= 135:
			current_view_direction = "D"
			animated_sprite_2d.flip_h = false
		elif 135 < angle_to_enemy or angle_to_enemy <= -135:
			current_view_direction = "S"
			animated_sprite_2d.flip_h = false
		elif -135 < angle_to_enemy and angle_to_enemy <= -45:
			current_view_direction = "U"
			animated_sprite_2d.flip_h = false
		elif -45 < angle_to_enemy or angle_to_enemy <= 45:
			current_view_direction = "S"
			animated_sprite_2d.flip_h = true
