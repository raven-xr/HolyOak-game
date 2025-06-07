extends Node



# These values are given by the level
var health: int:
	set(value):
		if value <= 0:
			value = 0
		health = value
		Signals.health_changed.emit(value)
var money: int = 0:
	set(value):
		money = value
		Signals.money_changed.emit(value)
var tower_level_limit: int
