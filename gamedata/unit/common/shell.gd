extends CharacterBody2D
class_name Shell

@export var effect_scene: PackedScene

@onready var hit = $SFX/Hit
@onready var area_2d = $Area2D

# These values are given by the parent (unit.gd)
var target: Enemy
var target_global_position: Vector2
var damage: int
var speed: int

# Common
func _ready():
	# Update the future health of the target
	# Needed for units
	# If the target is going to die (future_health became <= 0), it can't be detected
	target.future_health -= damage
	# Connect signals
	target.connect("died", Callable(self, "_on_target_died"))
	target.connect("moved", Callable(self, "_on_target_moved"))
	# Animation
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.67)

func _physics_process(delta):
	# Change direction if only target available (not dead or not too far)
	var direction = (target_global_position - global_position).normalized()
	look_at(target_global_position)
	velocity = direction * speed * delta
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body != target: return
	body.health -= damage
	hit.play()
	if effect_scene and body.health > 0:
		body.affect(effect_scene.instantiate())
	# These two (target.disconnect) lines prevent situations where the shell is too fast, 
	# so it manages to reach the enemy's position and start rotating.
	# If the signals are disconneted, shells just pass through the enemy, not rotate
	target.disconnect("died", Callable(self, "_on_target_died"))
	target.disconnect("moved", Callable(self, "_on_target_moved"))
	self_destruct()

func self_destruct():
	area_2d.set_deferred("monitoring", false)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	await tween.finished
	queue_free()

func _on_target_moved(new_position):
	target_global_position = new_position

func _on_target_died():
	self_destruct()
