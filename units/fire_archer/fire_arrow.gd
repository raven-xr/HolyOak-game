extends Shell



func _physics_process(delta):
	var direction = (target_global_position - global_position).normalized()
	look_at(target_global_position)
	# Fire mustn't rotate
	$Fire.look_at(-target_global_position)
	velocity = direction * speed * delta
	move_and_slide()
