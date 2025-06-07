extends NodeGUI

@onready var hp_value: Label = $PanelContainer/HBoxContainer/HPValue
@onready var money_value: Label = $PanelContainer/HBoxContainer/MoneyValue
@onready var wave_value: Label = $PanelContainer/HBoxContainer/WaveValue

func _ready() -> void:
	# Scale even more
	scale *= 2
	# Connect global signals of the "PlayerStats" autoloading script
	Signals.connect("money_changed", Callable(self, "_on_money_changed"))
	Signals.connect("wave_changed", Callable(self, "_on_wave_changed"))
	Signals.connect("health_changed", Callable(self, "_on_health_changed"))

func _on_money_changed(value: int) -> void:
	money_value.text = str(value)
	
func _on_wave_changed(value: int) -> void:
	wave_value.text = str(value)

func _on_health_changed(value: int) -> void:
	hp_value.text = str(value)
