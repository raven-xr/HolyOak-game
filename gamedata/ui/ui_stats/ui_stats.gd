extends PanelContainer

# Nodes
@onready var hp_value = $HBoxContainer/HPValue
@onready var money_value = $HBoxContainer/MoneyValue
@onready var wave_value = $HBoxContainer/WaveValue



# Common functions
func _ready():
	# Scale
	# Square the scale to get the best view
	scale = Vector2(UserSettings.gui_scale**2, UserSettings.gui_scale**2)
	# Connect signals
	Signals.connect("money_changed", Callable(self, "_on_money_changed"))
	Signals.connect("wave_changed", Callable(self, "_on_wave_changed"))
	Signals.connect("health_changed", Callable(self, "_on_health_changed"))

func _on_money_changed(value):
	money_value.text = str(value)
	
func _on_wave_changed(value):
	wave_value.text = str(value)

func _on_health_changed(value):
	hp_value.text = str(value)
