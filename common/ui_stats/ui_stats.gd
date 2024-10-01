extends CanvasLayer

@onready var money_value = $PanelContainer/HBoxContainer/MoneyValue
@onready var wave_value = $PanelContainer/HBoxContainer/WaveValue
@onready var hp_value = $PanelContainer/HBoxContainer/HPValue

func _ready():
	Signals.connect("money_changed", Callable(self, "_on_money_changed"))
	Signals.connect("wave_changed", Callable(self, "_on_wave_changed"))
	Signals.connect("health_changed", Callable(self, "_on_health_changed"))

func _on_money_changed(value):
	money_value.text = str(value)
	
func _on_wave_changed(value):
	wave_value.text = str(value)

func _on_health_changed(value):
	hp_value.text = str(value)
