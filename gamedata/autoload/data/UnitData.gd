extends Node

#const EXAMPLE = {
	#"level_1": {
		#"shell_speed": 7000, # float or int
		#"damage": 10, # int
		#"cost": 100, # int
		#"count": 1, # int
		#"spawnpoints": [Vector2(0, 0)], # Array[Vector2] with "count" items
		#"attack_range": 200, # int or float
	#}
#}

const ARCHER: Dictionary[StringName, Dictionary] = {
	"level_1": {
		"shell_speed": 7000,
		"damage": 10,
		"cost": 100,
		"count": 1,
		"spawnpoints": [Vector2(0, 0)],
		"attack_range": 200
	},
	"level_2": {
		"shell_speed": 7000,
		"damage": 20,
		"cost": 300,
		"count": 1,
		"spawnpoints": [Vector2(0, -20)],
		"attack_range": 225
	},
	"level_3": {
		"shell_speed": 7000,
		"damage": 20,
		"cost": 1000,
		"count": 2,
		"spawnpoints": [Vector2(-14, -35), Vector2(16, -35)],
		"attack_range": 250
	},
	"level_4": {
		"shell_speed": 7000,
		"damage": 30,
		"cost": 1800,
		"count": 2,
		"spawnpoints": [Vector2(16, -32), Vector2(-16, -32)],
		"attack_range": 275
	},
	"level_5": {
		"shell_speed": 7000,
		"damage": 30,
		"cost": 3600,
		"count": 3,
		"spawnpoints": [Vector2(0, -42), Vector2(-16, -32), Vector2(16, -32)],
		"attack_range": 300
	},
	"level_6": {
		"shell_speed": 7000,
		"damage": 40,
		"cost": 4800,
		"count": 3,
		"spawnpoints": [Vector2(0, -44), Vector2(-16, -34), Vector2(16, -34)],
		"attack_range": 325
	},
	"level_7": {
		"shell_speed": 7000,
		"damage": 50,
		"cost": 9600,
		"count": 3,
		"spawnpoints": [Vector2(0, -44), Vector2(-16, -34), Vector2(16, -34)],
		"attack_range": 350
	}
}

const FIRE_ARCHER: Dictionary[StringName, Dictionary] = {
	"level_1": {
		"shell_speed": 7000,
		"damage": 10,
		"cost": 150,
		"count": 1,
		"spawnpoints": [Vector2(0, 0)],
		"attack_range": 200
	},
	"level_2": {
		"shell_speed": 7000,
		"damage": 20,
		"cost": 450,
		"count": 1,
		"spawnpoints": [Vector2(0, -20)],
		"attack_range": 225
	},
	"level_3": {
		"shell_speed": 7000,
		"damage": 20,
		"cost": 1500,
		"count": 2,
		"spawnpoints": [Vector2(-14, -35), Vector2(16, -35)],
		"attack_range": 250
	},
	"level_4": {
		"shell_speed": 7000,
		"damage": 30,
		"cost": 2700,
		"count": 2,
		"spawnpoints": [Vector2(16, -32), Vector2(-16, -32)],
		"attack_range": 275
	},
	"level_5": {
		"shell_speed": 7000,
		"damage": 30,
		"cost": 5400,
		"count": 3,
		"spawnpoints": [Vector2(0, -42), Vector2(-16, -32), Vector2(16, -32)],
		"attack_range": 300
	},
	"level_6": {
		"shell_speed": 7000,
		"damage": 40,
		"cost": 7200,
		"count": 3,
		"spawnpoints": [Vector2(0, -44), Vector2(-16, -34), Vector2(16, -34)],
		"attack_range": 325
	},
	"level_7": {
		"shell_speed": 7000,
		"damage": 50,
		"cost": 14400,
		"count": 3,
		"spawnpoints": [Vector2(0, -44), Vector2(-16, -34), Vector2(16, -34)],
		"attack_range": 350
	}
}
