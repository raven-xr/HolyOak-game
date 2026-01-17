extends CharacterBody2D
class_name Shell

@export_group("Required Scenes")
@export var effect_scene: PackedScene
@export var hit_effect: PackedScene

@onready var hit: AudioStreamPlayer2D = $SFX/Hit
@onready var area_2d: Area2D = $Area2D

var is_self_destructing: bool = false
var direction: Vector2

var is_target_just_died: bool = false
# These values are given by the parent unit
var target: Enemy
var target_global_position: Vector2
var damage: int
var speed: int
var hit_enemy: bool = false

func _ready() -> void:
	# Decrease the future health of the target to serve the best interaction
	# Between enemies and units
	target.future_health -= damage
	# Connect signals
	target.connect("died", Callable(self, "_on_target_died"))
	target.connect("moved", Callable(self, "_on_target_moved"))
	# Change direction
	change_direction()
	# Animation
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.67)

func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	move_and_slide()
	if global_position.distance_to(target_global_position) < 10 and \
	(is_target_just_died or not is_instance_valid(target)) and \
	not is_self_destructing:
		hit.play()
		self_destruct()

func _on_area_2d_body_entered(body: Enemy) -> void:
	if body == target:
		hit_enemy = true
		body.health -= damage
		body.animated_sprite_2d.add_child(hit_effect.instantiate())
		hit.play()
		if effect_scene and body.health > 0:
			body.affect(effect_scene.instantiate())
		self_destruct()

func self_destruct() -> void:
	is_self_destructing = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)
	await get_tree().create_timer(0.11).timeout
	if not hit_enemy:
		var new_hit_effect: AnimatedSprite2D = hit_effect.instantiate()
		new_hit_effect.position = position
		Global.game_controller.current_2d_scene.map.add_child(new_hit_effect)
	await tween.finished
	queue_free()

func change_direction() -> void:
	direction = global_position.direction_to(target_global_position)
	look_at(target_global_position)

func _on_target_moved(new_position: Vector2) -> void:
	target_global_position = new_position
	if not is_self_destructing:
		change_direction()

func _on_target_died() -> void:
	is_target_just_died = true
