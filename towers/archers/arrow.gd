extends CharacterBody2D

const SPEED = 7000.0

var target_available = true
var direction: Vector2

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var hit_2d = $SFX/Hit2D

@onready var damage = get_parent().get_parent().get_parent().get_parent().damage
@onready var attack_range = get_parent().get_parent().get_parent().get_parent().attack_range

@onready var target = get_parent().get_parent().target
@onready var unit_global_position = get_parent().get_parent().global_position

func _ready():
	modulate = Color(1, 1, 1, 0)
	Signals.connect("target_die", Callable(self, "_on_target_die"))
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.67)

func _physics_process(delta):
	# If the arrow pass attack range, then self-destruct
	var distance_to_archer = unit_global_position.distance_to(global_position)
	if distance_to_archer > attack_range:
		self_destruct()
	# Change direction if only target available (not dead or not too far)
	if target_available:                
		direction = (target.global_position - global_position).normalized()
		look_at(target.global_position)
		velocity = direction * SPEED * delta
	# Move and Slide
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body == target:
		body.health -= damage
		hit_2d.play()
		self_destruct()

func _on_target_die(died_target):
	if target == died_target:
		self_destruct()

func self_destruct():
	target_available = false
	collision_shape_2d.set_deferred("disabled", "true")
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	await tween.finished
	queue_free()
