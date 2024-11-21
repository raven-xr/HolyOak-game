extends PathFollow2D

var speed: float = 0.0

func _process(delta):
	progress += speed * delta
	
	if progress_ratio == 1.0:
		var enemy = get_child(0)
		enemy.state = enemy.States.ATTACK
