extends Node

const ARCHER = {
	"shell_speed": 7000,
	"level_1": {
		"damage": 10,
		"cost": 100,
		"unit_count": 1,
		"spawnpoints": [Vector2(0, 0)],
		"attack_range": 200
	},
	"level_2": {
		"damage": 20,
		"cost": 200,
		"unit_count": 1,
		"spawnpoints": [Vector2(0, -20)],
		"attack_range": 225
	},
	"level_3": {
		"damage": 30,
		"cost": 600,
		"unit_count": 2,
		"spawnpoints": [Vector2(-14, -35), Vector2(16, -35)],
		"attack_range": 250
	},
	"level_4": {
		"damage": 40,
		"cost": 800,
		"unit_count": 2,
		"spawnpoints": [Vector2(16, -32), Vector2(-16, -32)],
		"attack_range": 275
	},
	"level_5": {
		"damage": 50,
		"cost": 1500,
		"unit_count": 3,
		"spawnpoints": [Vector2(0, -42), Vector2(-16, -32), Vector2(16, -32)],
		"attack_range": 300
	},
	"level_6": {
		"damage": 60,
		"cost": 1800,
		"unit_count": 3,
		"spawnpoints": [Vector2(0, -44), Vector2(-16, -34), Vector2(16, -34)],
		"attack_range": 325
	},
	"level_7": {
		"damage": 70,
		"cost": 2100,
		"unit_count": 3,
		"spawnpoints": [Vector2(0, -44), Vector2(-16, -34), Vector2(16, -34)],
		"attack_range": 350
	}
}