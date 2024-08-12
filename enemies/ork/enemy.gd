extends PathFollow2D

@onready var body = $CharacterBody2D

func _ready():
	body.walk()

func _process(delta):
	progress_ratio += body.SPEED * delta
	if progress_ratio == 1:
		body.attack()
		set_process(false)
