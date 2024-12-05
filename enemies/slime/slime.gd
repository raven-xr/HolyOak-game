extends Enemy



# Common
func split():
	animation_player.play(direction + "_Split")
	await animation_player.animation_finished
	
	position -= Vector2(4.0, 4.0)
	
	var new_path_follow_2d = path_follow_2d.duplicate()
	new_path_follow_2d.get_child(0).position += Vector2(4.0, 4.0)
	
	path_follow_2d.add_sibling(new_path_follow_2d)
	
	match state:
		States.MOVE: move_state()
		States.ATTACK: attack_state()
		States.DEATH: death_state()



# AnimationPlayer
func rest(): # Cooldown between jumps
	path_follow_2d.speed = 0.0

func jump():
	path_follow_2d.speed = stats["speed"]


# Timer
func _on_timer_timeout():
	split()
