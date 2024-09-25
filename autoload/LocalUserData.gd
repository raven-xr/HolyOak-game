extends Node

@warning_ignore("unused_signal")
signal player_built_towers()

func _ready():
	Signals.connect("tower_built", Callable(func(): tutorial_built_towers_count += 1))
	Signals.connect("tower_removed", Callable(func(): tutorial_built_towers_count -= 1))

var tutorial_built_towers_count = 0:
	set(value):
		tutorial_built_towers_count = value
		if tutorial_built_towers_count == 3:
			emit_signal("player_built_towers")
