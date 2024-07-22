extends CharacterBody2D

var speed = 100.0
var direction
var enemy_available = true:
	set(value):
		enemy_available = value
		self_destruction()
var distance_to_archer

@onready var enemy # The value is given by the archer
@onready var damage = get_parent().get_parent().get_parent().get_parent().damage
@onready var tower_position = get_parent().get_parent().get_parent().get_parent().global_position
# get_parent().get_parent().get_parent().get_parent() is a tower

func _ready():
	Signals.connect("enemy_die", Callable(self, "_on_enemy_die"))
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.67)

func _physics_process(_delta):
	if enemy_available:
		direction = (enemy.position - self.global_position).normalized()
		look_at(enemy.position)
		distance_to_archer = sqrt((tower_position - self.global_position).x**2 + (tower_position - self.global_position).y**2)
		if distance_to_archer > 300: # If the distance to the tower more than 300,
			enemy_available = false  # then the arrow selfdestroys
		velocity = direction * speed
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body == enemy:
		body.health -= damage
		queue_free()

func _on_enemy_die(died_enemy):
	if enemy == died_enemy:
		enemy_available = false

func self_destruction():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.33)
	await tween.finished
	queue_free()
