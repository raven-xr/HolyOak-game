extends Area2D

enum {
	WALK,
	ATTACK,
	DEATH
}

func _on_body_entered(body):
	body.state = ATTACK
