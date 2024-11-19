extends CharacterBody2D

var target_global_position: Vector2
var target_available: bool = true
var direction: Vector2

@onready var hit = $SFX/Hit
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var damage = get_parent().get_parent().get_parent().get_parent().damage
@onready var target = get_parent().get_parent().target
@onready var unit_global_position = get_parent().get_parent().global_position
@onready var speed = UnitData.get(get_parent().get_parent().name.to_upper())["shell_speed"]

func _ready():
	modulate = Color(1, 1, 1, 0)
	Signals.connect("target_died", Callable(self, "_on_target_died"))
	target.connect("moved", Callable(self, "_on_target_moved"))
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.67)

func _physics_process(delta):
	# Change direction if only target available (not dead or not too far)
	if target_available:            
		direction = (target_global_position - global_position).normalized()
		look_at(target_global_position)
		velocity = direction * speed * delta

	move_and_slide()

func _on_area_2d_body_entered(body):
	if body == target:
		body.health -= damage
		hit.play()
		self_destruct()

func _on_target_moved(new_position):
	target_global_position = new_position

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
