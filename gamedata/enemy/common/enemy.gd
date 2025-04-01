extends CharacterBody2D
class_name Enemy

@export var technical_name: StringName

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var pivot: Area2D = $Pivot
@onready var death: AudioStreamPlayer2D = $SFX/Death
@onready var hit_sfx: AudioStreamPlayer2D = $SFX/Hit
@onready var effects: Node2D = $Effects

@onready var stats: Dictionary = EnemyData.get(technical_name)
@onready var speed: int = stats["speed"]
@onready var health: int = stats["health"]:
	set(value):
		health = value
		if health <= 0:
			die()
@onready var damage: int = stats["damage"]
@onready var reward: int = stats["reward"]

## This variable is used in unit.gd when a unit chooses the best target
@onready var future_health: int = health:
	set(value):
		future_health = value
		# If an enemy is going to die, make him invisible for attack ranges of units
		if future_health <= 0:
			is_previously_died = true

var direction: Vector2 # Updates in next_roadpoint_position's setter
var view_direction: String: # The value is being given by points on the road
	set(value):
		view_direction = value
		# If the enemy is available and isn't dying, then update his animation
		if is_available and not "Death" in animation_player.current_animation:
			animation_player.play(value + "_Move")
var next_roadpoint_position: Vector2:
	set(value):
		next_roadpoint_position = value
		if is_available:
			direction = (value - position).normalized()
## If the enemy isn't available, he can't change its direction and animation.[br]
## If he gets available, the enemy updates its animation and direction.
var is_available: bool = true:
	set(value):
		is_available = value
		if is_available:
			animation_player.play(view_direction + "_Move")
			direction = (next_roadpoint_position - position).normalized()
## If the enemy previously dies (future_health <= 0),
## it becomes less of a priority for units
var is_previously_died: bool = false

signal moved()
signal died()

func _physics_process(delta: float) -> void:
	velocity = speed * direction * delta
	move_and_slide()
	moved.emit(collision_shape_2d.global_position)

func attack() -> void:
	speed = 0
	animation_player.play(view_direction + "_Attack")

func hit() -> void:
	PlayerStats.health -= damage
	hit_sfx.play()

func die() -> void:
	set_physics_process(false)
	collision_shape_2d.set_deferred("disabled", true)
	death.play()
	died.emit()
	PlayerStats.money += reward
	animation_player.play(view_direction + "_Death")
	await animation_player.animation_finished
	queue_free()

func affect(effect: Effect) -> void:
	# If the enemy already has the given effect, then extend it
	if is_affected(effect):
		for active_effect: Effect in effects.get_children():
			if active_effect.technical_name == effect.technical_name:
				active_effect.enemy.future_health -= active_effect.total_damage
				active_effect.total_damage = 0
				break
	else:
		effects.add_child(effect)

func is_affected(effect: Effect) -> bool:
	for active_effect: Effect in effects.get_children():
		if active_effect.technical_name == effect.technical_name:
			return true
	return false
