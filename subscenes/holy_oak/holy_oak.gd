extends Node2D

@onready var leaves = $GFX/Leaves
@onready var health_bar = $HealthBar

func _ready():
	Signals.connect("health_change", Callable(self, "_on_health_change"))

func _on_health_change(health):
	if health < health_bar.value: # At the start of the level
		leaves.emitting = true
		health_bar.max_value = health
	health_bar.value = health
