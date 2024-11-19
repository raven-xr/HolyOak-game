extends Node

const TUTORIAL = {
	"health": 100,
	"money": 300,
	"max_level": 2,
	"wave_count": 3,
	
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

const LEVEL_1 = {}
