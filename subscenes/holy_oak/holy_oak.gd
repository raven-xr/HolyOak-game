extends Node2D

@onready var leaves = $GFX/Leaves
@onready var health_bar = $HealthBar

func _ready():
	Signals.connect("health_change", Callable(self, "_on_health_change"))

func _on_health_change(value):
	if value < health_bar.value: # If health decreased
		leaves.emitting = true
	if value > health_bar.max_value:
		health_bar.max_value = value
	health_bar.value = value
