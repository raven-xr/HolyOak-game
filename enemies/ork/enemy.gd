extends PathFollow2D

enum {
	WALK,
	ATTACK,
	DEATH
}

@onready var body = $CharacterBody2D

func _ready():
	body.state = WALK

func _process(delta):
	progress_ratio += body.SPEED * delta
