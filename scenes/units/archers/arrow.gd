extends CharacterBody2D

const SPEED = 6000.0
var enemy_available = true:
	set(value):
		enemy_available = value
		self_destruct()

@onready var collision_shape_2d = $Area2D/CollisionShape2D

@onready var damage = get_parent().get_parent().get_parent().get_parent().damage
@onready var attack_range = get_parent().get_parent().get_parent().get_parent().attack_range

@onready var enemy = get_parent().get_parent().enemy
@onready var unit_global_position = get_parent().get_parent().global_position

func _ready():
	self.modulate = Color(1, 1, 1, 0)
	Signals.connect("enemy_die", Callable(self, "_on_enemy_die"))
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.67)

func _physics_process(delta):
	# If the arrow pass attack range, then self-destruct
	var distance_to_archer = sqrt((unit_global_position - self.global_position).x**2 + (unit_global_position - self.global_position).y**2)
	if distance_to_archer > attack_range:
		enemy_available = false # Trigger self-destruction
	# Change direction if only enemy available (not dead or not too far)
	if enemy_available:                
		var direction = (enemy.global_position - self.global_position).normalized()
		look_at(enemy.global_position)
		velocity = direction * SPEED * delta
	# Move and Slide
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body == enemy:
		body.health -= damage
		queue_free()

func _on_enemy_die(died_enemy):
	if enemy == died_enemy:
		enemy_available = false

func self_destruct():
	collision_shape_2d.set_deferred("disabled", "true")
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.33)
	tween.connect("finished", Callable(self, "queue_free"))
