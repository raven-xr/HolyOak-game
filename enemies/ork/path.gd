extends PathFollow2D

@onready var body = $Ork

func _process(delta):
	progress_ratio += body.SPEED * delta
