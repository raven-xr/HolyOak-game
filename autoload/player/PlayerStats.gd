extends Node



# These values are given by the level
var health: int:
	set(value):
		if value <= 0:
			value = 0
		health = value
		Signals.emit_signal("health_changed", health)
var money: int:
	set(value):
		money = value
		Signals.emit_signal("money_changed", money)
var tower_level_limit: int
