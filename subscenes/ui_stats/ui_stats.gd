extends CanvasLayer

@onready var money_value = $PanelContainer/HBoxContainer/MoneyValue
@onready var wave_value = $PanelContainer/HBoxContainer/WaveValue

func _ready():
	Signals.connect("money_change", Callable(self, "_on_money_change"))
	Signals.connect("wave_change", Callable(self, "_on_wave_change"))

func _on_money_change(value):
	money_value.text = str(value)
	
func _on_wave_change(value):
	wave_value.text = str(value)
