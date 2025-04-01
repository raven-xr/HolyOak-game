extends CharacterBody2D
class_name Shell

@export var effect_scene: PackedScene

@onready var hit: AudioStreamPlayer2D = $SFX/Hit
@onready var area_2d: Area2D = $Area2D

var is_self_destructing: bool = false
var direction: Vector2

var is_target_died: bool = false
var target: Enemy # Defined by the parent unit
var target_global_position: Vector2
var damage: int # Defined by the parent unit
var speed: int # Defined by the parent unit

func _ready() -> void:
	# Decrease the future health of the target to serve the best interaction
	# Between enemies and units
	target.future_health -= damage
	# Then the value will be changed "_on_target_moved"
	target_global_position = target.global_position
	# Connect signals
	target.connect("died", Callable(self, "_on_target_died"))
	target.connect("moved", Callable(self, "_on_target_moved"))
	# Animation
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.67)

func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	move_and_slide()
	if global_position.distance_to(target_global_position) < 10 and \
	is_target_died and not is_self_destructing:
		hit.play()
		self_destruct()

func _on_area_2d_body_entered(body: Enemy) -> void:
	if body != target: return
	body.health -= damage
	hit.play()
	if effect_scene and body.health > 0:
		body.affect(effect_scene.instantiate())
	self_destruct()

func self_destruct() -> void:
	is_self_destructing = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	await tween.finished
	queue_free()

func _on_target_moved(new_position: Vector2) -> void:
	target_global_position = new_position
	if not is_self_destructing:
		direction = global_position.direction_to(target_global_position)
		look_at(target_global_position)

func _on_target_died() -> void:
	is_target_died = true
