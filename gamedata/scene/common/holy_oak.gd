extends Node2D

@onready var leaves: GPUParticles2D = $Leaves
@onready var hearts: GPUParticles2D = $Hearts
@onready var health_bar: TextureProgressBar = $HealthBar

func _ready() -> void:
	health_bar.scale = Vector2(UserSettings.gui_scale*2, UserSettings.gui_scale*2)
	Signals.connect("health_changed", Callable(self, "_on_health_changed"))
	Signals.connect("health_decreased", Callable(self, "_on_health_decreased"))
	Signals.connect("health_increased", Callable(self, "_on_health_increased"))

func _on_health_changed(value: int) -> void:
	if value > health_bar.max_value:
		health_bar.max_value = value
	health_bar.value = value

func _on_health_decreased(_value: int) -> void:
	leaves.emitting = true

func _on_health_increased(_value: int) -> void:
	hearts.emitting = true
