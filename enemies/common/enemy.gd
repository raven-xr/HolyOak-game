extends CharacterBody2D
class_name Enemy



@export var technical_name: StringName



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



var direction: Vector2 # Updates in next_roadpoint_position's setter
var view_direction: String: # The value is being given by points on the road
	set(value):
		view_direction = value
		if is_available:
			animation_player.play(value + "_Move")
var next_roadpoint_position: Vector2:
	set(value):
		next_roadpoint_position = value
		if is_available:
			direction = (value - position).normalized()
## If an enemy isn't available, he can't change its direction and animation.[br]
## If he gets available, the enemy updates its animation and direction.
var is_available: bool = true:
	set(value):
		is_available = value
		if is_available:
			animation_player.play(view_direction + "_Move")
			direction = (next_roadpoint_position - position).normalized()

## This variable is used in unit.gd when a unit chooses the best target
var future_health: int:
	set(value):
		future_health = value
		# If an enemy is going to die, make him invisible for attack ranges of units
		if future_health <= 0:
			set_collision_layer_value(1, false)



signal moved()
signal died()



# Common
func _ready():
	future_health = health

func _physics_process(delta):
	velocity = speed * direction * delta
	move_and_slide()
	moved.emit(global_position)

func attack():
	speed = 0
	animation_player.play(view_direction + "_Attack")

func hit():
	PlayerStats.health -= damage
	hit_sfx.play()

func die():
	death.play()
	died.emit()
	speed = 0
	collision_shape_2d.set_deferred("disabled", true)
	PlayerStats.money += reward
	animation_player.play(str(view_direction, "_Death"))
	await animation_player.animation_finished
	queue_free()
