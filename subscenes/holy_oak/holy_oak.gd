extends StaticBody2D

@onready var leaves = $GFX/Leaves

var health = 100:
	set(value):
		health = value
		leaves.emitting = true
