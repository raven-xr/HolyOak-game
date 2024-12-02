extends Enemy



# Called by AnimationPlayer
func rest(): # Cooldown between jumps
	path_follow_2d.speed = 0.0

func jump():
	path_follow_2d.speed = stats["speed"]
