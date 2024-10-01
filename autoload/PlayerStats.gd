extends Node

# These values are given by the level
var health: int:
	set(value):
		health = value
		Signals.emit_signal("health_changed", health)
var money: int:
	set(value):
		money = value
		Signals.emit_signal("money_changed", money)
var max_level: int # {1; 2; 3; 4; 5; 6; 7}
