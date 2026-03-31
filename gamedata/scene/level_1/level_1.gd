extends Level

@onready var hint: NodeGUI = $GlobalGUI/Hint
@onready var tower_1: Node2D = $"Towers/Tower 1"

func idle_state() -> void:
	SoundManager.music_idle.play()
	tutorial()

func tutorial() -> void:
	# Greeting
	hint.text = "Здравствуйте, вождь. Добро пожаловать в Holy Oak!"
	hint.pivot_offset.x = 96.0
	hint.position = Vector2(544.0, 320.0)
	hint.show_()
	await hint.hidden_
	
	# Point of the game
	hint.text = "Ваша задача — любыми способами защитить Священный Дуб"
	hint.show_()
	await hint.hidden_
	
	hint.text = "Если наши злостные враги его уничтожат, то наша земля будет под серьёзной угрозой"
	hint.show_()
	await hint.hidden_
	
	# Camera zooming in
	hint.text = "Вы можете управлять камерой. Вращайте колёсико мыши вперёд, чтобы приблизить камеру"
	hint.can_be_skipped = false
	hint.show_()
	await camera.zoomed_in
	SoundManager.click.play()
	hint.hide_()
	await hint.hidden_
	
	# Camera movement
	hint.text = "Чтобы перемещаться по карте, зажмите ЛКМ и двигайте курсор в противоположном направлении"
	hint.show_()
	await camera.moved
	SoundManager.click.play()
	hint.hide_()
	await hint.hidden_
	
	# Camera zooming out
	hint.text = "Вы можете и отдалить камеру. Для этого вращайте колёсико мыши назад"
	hint.show_()
	await camera.zoomed_out
	SoundManager.click.play()
	hint.hide_()
	await hint.hidden_
	
	# How to defend
	hint.text = "Есть разные способы защитить сердце нашего королевства. Но мы выберем самый эффективный"
	hint.can_be_skipped = true
	hint.show_()
	await hint.hidden_
	
	# Open the tower menu
	hint.text = "Нажмите на пустое поле справа, рядом с подсказкой"
	hint.pivot_offset.x = 192.0
	hint.position = Vector2(432.0, 136.0)
	hint.can_be_skipped = false
	hint.show_()
	# Unlock the tower 1
	tower_1.set_process_mode(Node.PROCESS_MODE_INHERIT)
	# Await for player to open the tower menu
	await tower_1.player_opened_menu
	hint.hide_()
	await hint.hidden_
	# Build the tower
	hint.text = "Теперь нажмите BUILD, чтобы её построить"
	hint.show_()
	# Await for player to build the tower
	await tower_1.player_built_tower
	hint.hide_()
	await hint.hidden_
	# Upgrade the tower
	hint.text = "Для того чтобы повысить эффективность защиты, необходимо улучшить башню. Откройте меню и нажмите UPGRADE"
	hint.show_()
	# Await for player to upgrade the tower
	await tower_1.player_upgraded_tower
	hint.hide_()
	await hint.hidden_
	# Check current stats
	hint.text = "Отлично. Нажмите на кнопку STATS, чтобы посмотреть текущие характеристики башни и юнитов"
	hint.show_()
	# Unlock the TowerStats button
	tower_1.is_tower_stats_button_locked = false
	# Await for player to check current stats
	await tower_1.player_opened_tower_stats
	hint.hide_()
	await hint.hidden_
	# Tell about removing towers
	hint.text = "Запомните, что в случае, если нужно построить башню в другом месте, а у вас не хватит монет, вы всегда можете избавиться от другой, нажав REMOVE и вернув все потраченные на неё средства"
	hint.can_be_skipped = true
	hint.show_()
	# Await for player to close the hint
	await hint.hidden_
	# Say goodbye
	hint.text = "О, нет! Вы это слышите? Враг надвигается!.. Всё в ваших руках, вождь!"
	hint.pivot_offset.x = 96.0
	hint.position = Vector2(544.0, 320.0)
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
