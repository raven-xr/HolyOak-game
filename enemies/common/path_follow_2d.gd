extends PathFollow2D

var path_speed: float = 0.0 # Updates as a child appears

func _process(delta):
	progress_ratio += path_speed * delta
