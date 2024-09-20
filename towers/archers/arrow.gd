extends CharacterBody2D

const SPEED = 7000.0

var target_available = true
var direction: Vector2

@onready var bow_hit = $SFX/BowHit
@onready var collision_shape_2d = $Area2D/CollisionShape2D

@onready var damage = get_parent().get_parent().get_parent().get_parent().damage

@onready var target = get_parent().get_parent().target
@onready var unit_global_position = get_parent().get_parent().global_position

func _ready():
	modulate = Color(1, 1, 1, 0)
	Signals.connect("target_died", Callable(self, "_on_target_died"))
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.67)

func _physics_process(delta):
	# Change direction if only target available (not dead or not too far)
	#await get_tree().create_timer(1 / Engine.get_frames_per_second()).timeout
	if target_available:            
		direction = (target.global_position - global_position).normalized()
		look_at(target.global_position)
		velocity = direction * SPEED * delta
	# Move and Slide
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body == target:
		body.health -= damage
		bow_hit.play()
		self_destruct()

func _on_target_died(body):
	if target == body:
		self_destruct()

func self_destruct():
	target_available = false
	collision_shape_2d.set_deferred("disabled", "true")
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	await tween.finished
	queue_free()
