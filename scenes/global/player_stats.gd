extends Node

# These values are given by the level
var money: int:
	set(value):
		money = value
		Signals.emit_signal("money_change", money)
var max_level: int # {1; 2; 3; 4; 5; 6; 7}
