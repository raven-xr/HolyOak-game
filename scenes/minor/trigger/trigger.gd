extends Area2D

@export var direction: String = "D"

func _on_body_entered(body):
	body.direction = direction
