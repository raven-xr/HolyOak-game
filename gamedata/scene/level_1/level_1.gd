extends Level

@onready var hint: Control = $UserInterface/Hint
@onready var towers: Node2D = $Towers
@onready var tower_1: Node2D = $"Towers/Tower 1"

func idle_state() -> void:
	SoundManager.music_idle.play()
	tutorial()

func tutorial() -> void:
	# Greet
	hint.text = "Здравствуй, вождь. Добро пожаловать в Holy Oak!"
	hint.pivot_offset.x = 64.0
	hint.position = Vector2(576.0, 320.0)
	hint.show_()
	await hint.hidden_
	# Await for player to close the hint
	hint.text = "В этой игре ваша главная задача - защитить Священный дуб"
	hint.show_()
	await hint.hidden_
	# Open the tower menu
	hint.text = "Для начала построим башню. Нажмите на пустое поле справа от подсказки"
	hint.pivot_offset.x = 128.0
	hint.position = Vector2(484.0, 128.0)
	hint.can_be_pressed = false
	hint.show_()
	# Unlock the tower 1
	tower_1.set_process_mode(Node.PROCESS_MODE_INHERIT)
	# Await for player to open the tower menu
	await tower_1.player_opened_menu
	hint.hide_()
	await hint.hidden_
	# Build the tower
	hint.text = "Теперь нажмите 'Build', чтобы её построить"
	hint.show_()
	# Await for player to build the tower
	await tower_1.player_built_tower
	hint.hide_()
	await hint.hidden_
	# Upgrade the tower
	hint.text = "Чтобы повысить эффективность защиты, необходимо улучшить башню. Откройте меню и нажмите 'Upgrade'"
	hint.show_()
	# Await for player to upgrade the tower
	await tower_1.player_upgraded_tower
	hint.hide_()
	await hint.hidden_
	# Check current stats
	hint.text = "Отлично. Нажми на кнопку 'Stats', чтобы посмотреть текущие характеристики башни и юнитов"
	hint.show_()
	# Unlock the TowerStats button
	tower_1.is_tower_stats_button_locked = false
	# Await for player to check current stats
	await tower_1.player_opened_tower_stats
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
	hint.pivot_offset.x = 64.0
	hint.position = Vector2(576.0, 320.0)
	hint.show_()
	# Await for player to close the hint
	await hint.hidden_
	# End the tutorial
	hint.close()
	# Unlock the remove button of the tower 1
	tower_1.is_remove_button_locked = false
	# Unlock tower
	for tower in towers.get_children():
		tower.set_process_mode(Node.PROCESS_MODE_INHERIT)
	state = States.FIGHT
