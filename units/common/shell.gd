extends CharacterBody2D



@onready var hit = $SFX/Hit
@onready var area_2d = $Area2D



# These values are given by the parent (unit.gd)
var target: Enemy
var target_global_position: Vector2

var damage: int
var speed: int



# Common
func _ready():
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
	if body == target:
		body.health -= damage
		hit.play()
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
