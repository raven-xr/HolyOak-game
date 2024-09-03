extends Sprite2D

@onready var leaves = $GFX/Leaves
@onready var health_bar = $HealthBar

func _ready():
	Signals.connect("health_change", Callable(self, "_on_health_change"))

func _on_health_change(health):
	leaves.emitting = true
	health_bar.value = health
