extends CharacterBody2D
class_name Enemy



@export var technical_name: StringName



@onready var pivot = $Pivot
@onready var death = $SFX/Death
@onready var hit_sfx = $SFX/Hit
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $CollisionShape2D

@onready var stats: Dictionary = EnemyData.get(technical_name)
@onready var speed: int = stats["speed"]
@onready var health: int = stats["health"]:
	set(value):
		health = value
		if health <= 0:
			die()
@onready var damage: int = stats["damage"]
@onready var reward: int = stats["reward"]



var move_direction: Vector2 = Vector2(0.0, 0.0)
var direction: String: # The value is being given by the path: Up (U), Right (R), Down (D) or Left (L)
	set(value):
		direction = value
		if is_available:
			animation_player.play(value + "_Move")
var next_roadpoint_position: Vector2:
	set(value):
		next_roadpoint_position = value
		if is_available:
			move_direction = (value - position).normalized()
var is_available: bool = true:
	set(value):
		is_available = value
		if is_available:
			animation_player.play(direction + "_Move")
			move_direction = (next_roadpoint_position - position).normalized()



signal moved()



func _process(_delta):
	moved.emit(global_position)

func _physics_process(delta):
	velocity = speed * move_direction * delta
	move_and_slide()

func attack():
	set_physics_process(false)
	animation_player.play(direction + "_Attack")

func hit():
	PlayerStats.health -= damage
	hit_sfx.play()

func die():
	death.play()
	Signals.emit_signal("target_died", self)
	collision_shape_2d.set_deferred("disabled", true)
	pivot.set_deferred("monitorable", false)
	PlayerStats.money += reward
	set_physics_process(false)
	animation_player.play(str(direction, "_Death"))
	await animation_player.animation_finished
	queue_free()
