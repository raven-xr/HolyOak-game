extends Level



@onready var towers = $Towers

@onready var platform_1 = $"Towers/Platform 1"



signal player_opened_platform()
signal player_built_tower()
signal player_upgraded_tower()
signal player_checked_stats()
signal player_ended_tutorial()



# Common
func idle_state():
	SoundManager.music_idle.play()
	tutorial()

func tutorial():
	# Get ready
	var hint = hint_scene.instantiate()
	add_child(hint)
	# Greet
	hint.text = "Здравствуй, вождь. Добро пожаловать в Holy Oak!"
	hint.position = Vector2(576.0, 320.0)
	hint.show_()
	await hint.hidden_
	# Await for player to close the hint
	hint.text = "В этой игре ваша главная задача - защитить Священный дуб"
	hint.show_()
	await hint.hidden_
	
	# Open the platform menu
	hint.text = "Для начала построим башню. Нажмите на пустое поле слева"
	hint.position = Vector2(824.0, 128.0)
	hint.can_be_pressed = false
	hint.show_()
	# Unblock the platform 1
	platform_1.set_process_mode(Node.PROCESS_MODE_INHERIT)
	# Await for player to open the platform menu
	await player_opened_platform
	hint.hide_()
	await hint.hidden_
	
	# Build the tower
	hint.text = "Теперь нажмите 'Build', чтобы её построить"
	hint.show_()
	# Await for player to build the tower
	await player_built_tower
	hint.hide_()
	await hint.hidden_
	
	# Upgrade the tower
	hint.text = "Чтобы повысить эффективность защиты, необходимо улучшить башню. Откройте меню и нажмите 'Upgrade'"
	hint.show_()
	# Await for player to upgrade the tower
	await player_upgraded_tower
	hint.hide_()
	await hint.hidden_
	
	# Check current stats
	hint.text = "Отлично. Нажми на кнопку 'Stats', чтобы посмотреть текущие характеристики башни и юнитов"
	hint.show_()
	# Unblock the TowerStats button
	platform_1.tower_stats_button.disconnect("mouse_entered", Callable(platform_1, "_on_local_tower_stats_button_mouse_entered"))
	# Await for player to check current stats
	await player_checked_stats
	hint.hide_()
	await hint.hidden_
	
	# Tell about removing towers
	hint.text = "Запомни, что в случае, если нужно построить башню в другом месте, а у тебя не хватает денег, ты всегда можешь избавиться от другой, нажав 'Remove' и получив обратно 50% от стоимости (уничтожать эту башню не нужно)"
	hint.can_be_pressed = true
	hint.show_()
	# Await for player to close the hint
	await hint.hidden_
	
	# Say goodbye
	hint.text = "О, нет! Вы это слышите? Враг надвигается!.. Всё в ваших руках, вождь!"
	hint.position = Vector2(576.0, 320.0)
	hint.show_()
	# Await for player to close the hint
	await hint.hidden_
	
	# End the tutorial
	hint.close()
	player_ended_tutorial.emit()
	for platform in towers.get_children():
		platform.set_process_mode(Node.PROCESS_MODE_INHERIT)
	state = States.FIGHT
