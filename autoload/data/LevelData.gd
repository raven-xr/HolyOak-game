extends Node

const LEVEL_1 = {
	# Start data
	"health": 100,
	"money": 300,
	"max_level": 2,
	"wave_count": 3,
	# Waves
	"wave_1": {
		"spawn_cooldown": 2.0,
		"enemies": [
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"}
		]
	},
	"wave_2": {
		"spawn_cooldown": 2.0,
		"enemies": [
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"}
		]
	},
	"wave_3": {
		"spawn_cooldown": 1.5,
		"enemies": [
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "1"}
		]
	}
}

const LEVEL_2 = {
	# Start data
	"health": 100,
	"money": 200,
	"max_level": 3,
	"wave_count": 5,
	# Waves
	"wave_1": {
		"spawn_cooldown": 2.0,
		"enemies": [
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"}
		]
	},
	"wave_2": {
		"spawn_cooldown": 1.5,
		"enemies": [
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"}
		]
	},
	"wave_3": {
		"spawn_cooldown": 1,
		"enemies": [
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"}
		]
	},
	"wave_4": {
		"spawn_cooldown": 0.75,
		"enemies": [
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
		]
	},
	"wave_5": {
		"spawn_cooldown": 0.75,
		"enemies": [
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "ork", "road": "1"},
			{"type": "ork", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"},
			{"type": "slime", "road": "1"},
			{"type": "slime", "road": "2"}
		]
	}
}
