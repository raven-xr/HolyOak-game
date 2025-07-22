extends Level

@onready var hint: NodeGUI = $GUI/Hint
@onready var tower_1: Node2D = $"Towers/Tower 1"

func idle_state() -> void:
	SoundManager.music_idle.play()
	tutorial()

func tutorial() -> void:
	# Greet
	hint.text = tr("HINT_GREETING")
	hint.pivot_offset.x = 64.0
	hint.position = Vector2(576.0, 320.0)
	hint.show_()
	await hint.hidden_
	# Await for player to close the hint
	hint.text = tr("HINT_GAME_TASK")
	hint.show_()
	await hint.hidden_
	# Open the tower menu
	hint.text = tr("HINT_TOWER_MENU")
	hint.pivot_offset.x = 128.0
	hint.position = Vector2(484.0, 128.0)
	hint.can_be_skipped = false
	hint.show_()
	# Unlock the tower 1
	tower_1.set_process_mode(Node.PROCESS_MODE_INHERIT)
	# Await for player to open the tower menu
	await tower_1.player_opened_menu
	hint.hide_()
	await hint.hidden_
	# Build the tower
	hint.text = tr("HINT_BUILD_TOWER")
	hint.show_()
	# Await for player to build the tower
	await tower_1.player_built_tower
	hint.hide_()
	await hint.hidden_
	# Upgrade the tower
	hint.text = tr("HINT_UPGRADE_TOWER")
	hint.show_()
	# Await for player to upgrade the tower
	await tower_1.player_upgraded_tower
	hint.hide_()
	await hint.hidden_
	# Check current stats
	hint.text = tr("HINT_TOWER_STATS")
	hint.show_()
	# Unlock the TowerStats button
	tower_1.is_tower_stats_button_locked = false
	# Await for player to check current stats
	await tower_1.player_opened_tower_stats
	hint.hide_()
	await hint.hidden_
	# Tell about removing towers
	hint.text = tr("HINT_REMOVE_TOWER")
	hint.can_be_skipped = true
	hint.show_()
	# Await for player to close the hint
	await hint.hidden_
	# Say goodbye
	hint.text = tr("HINT_GOODBYE")
	hint.pivot_offset.x = 64.0
	hint.position = Vector2(576.0, 320.0)
	hint.show_()
	# Await for player to close the hint
	await hint.hidden_
	# End the tutorial
	hint.queue_free()
	# Unlock the remove button of the tower 1
	tower_1.is_remove_button_locked = false
	# Unlock the interaction with the other towers
	$"Towers/Tower 2".set_process_mode(Node.PROCESS_MODE_INHERIT)
	$"Towers/Tower 3".set_process_mode(Node.PROCESS_MODE_INHERIT)
	state = States.FIGHT
