extends Enemy



# AnimationPlayer
func rest(): # Cooldown between jumps
	is_available = true
	speed = 0

func jump():
	is_available = false
	speed = stats["speed"]
