extends Enemy



# AnimationPlayer
func rest(): # Cooldown between jumps
	can_rotate = true
	speed = 0

func jump():
	can_rotate = false
	speed = stats["speed"]
