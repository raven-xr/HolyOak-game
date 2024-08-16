extends PathFollow2D

@onready var body = $CharacterBody2D

func _process(delta):
	progress_ratio += body.SPEED * delta
