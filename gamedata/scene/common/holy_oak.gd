extends Node2D

@onready var leaves: GPUParticles2D = $Leaves
@onready var health_bar: TextureProgressBar = $HealthBar

func _ready() -> void:
	health_bar.scale = Vector2(UserSettings.gui_scale*2, UserSettings.gui_scale*2)
	Signals.connect("health_changed", Callable(self, "_on_health_changed"))

func _on_health_changed(value) -> void:
	if value < health_bar.value: # If health decreased, emit the "leaves" particles
		leaves.emitting = true
	if value > health_bar.max_value:
		health_bar.max_value = value
	health_bar.value = value
