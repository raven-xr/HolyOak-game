extends Node2D

# Nodes
@onready var leaves = $GFX/Leaves
@onready var health_bar = $HealthBar



# Common functions
func _ready():
	# Scale the health bar
	# Multiply by 2 because default scale is 2
	health_bar.scale = Vector2(UserSettings.gui_scale*2, UserSettings.gui_scale*2)
	# Connect signals
	Signals.connect("health_changed", Callable(self, "_on_health_changed"))

func _on_health_changed(value):
	if value < health_bar.value: # If health decreased
		leaves.emitting = true
	if value > health_bar.max_value:
		health_bar.max_value = value
	health_bar.value = value
