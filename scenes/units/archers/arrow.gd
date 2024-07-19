extends CharacterBody2D

var speed = 100.0
var damage = 10
#var direction
#var enemy
#var enemy_available = true

#func _ready():
	#Signals.connect("enemy_die", Callable(self, "_on_enemy_die"))

func _on_area_2d_body_entered(body):
	body.health -= damage
	queue_free()

#func _physics_process(_delta):
	#if enemy_available:
		#direction = (enemy.position - self.global_position).normalized()
		#look_at(enemy.position)
	#velocity = direction * SPEED
	#move_and_slide()
#
#func _on_enemy_die(died_enemy):
	#if enemy == died_enemy:
		#self_destruction()
		#
#func self_destruction():
	#enemy_available = false
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)
	#await tween.finished
	#queue_free()
