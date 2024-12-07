extends Enemy



func split():
	path_follow_2d.speed = 0.0
	animation_player.play(direction + "_Split")
	await animation_player.animation_finished
	position.x -= 24.0
	var new_path_follow_2d = path_follow_2d.duplicate()
	var new_slime = new_path_follow_2d.get_child(0)
	new_slime.position.x += 24.0
	path_follow_2d.add_sibling(new_path_follow_2d)
	# Update animation
	animation_player.play(direction + "_Move")
	new_slime.animation_player.play(direction + "_Move")



# AnimationPlayer
func rest(): # Cooldown between jumps
	path_follow_2d.speed = 0.0

func jump():
	path_follow_2d.speed = stats["speed"]



# Timer
func _on_timer_timeout():
	split()
