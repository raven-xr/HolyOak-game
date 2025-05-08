extends Control

@export var message_scene: PackedScene

@onready var master_h_slider: HSlider = $"PanelContainer/VBoxContainer/Master Volume/Master HSlider"
@onready var music_h_slider: HSlider = $"PanelContainer/VBoxContainer/Music Volume/Music HSlider"
@onready var sfx_h_slider: HSlider = $"PanelContainer/VBoxContainer/SFX Volume/SFX HSlider"
@onready var scale_option_button: OptionButton = $"PanelContainer/VBoxContainer/GUI Scale/Scale OptionButton"

@onready var confirmation: Control = $"PanelContainer/VBoxContainer/Data Reset/Reset Progress Button/Confirmation"

@onready var reset_progress_button: Button = $"PanelContainer/VBoxContainer/Data Reset/Reset Progress Button"

# Previous settings (will be used, if player didn't apply settings)
# Gets values when settings is opened
var last_master_volume: float = UserSettings.master_volume
var last_music_volume: float = UserSettings.music_volume
var last_sfx_volume: float = UserSettings.sfx_volume
var last_gui_scale: float = UserSettings.gui_scale

func _ready() -> void:
	# Connects signal
	scale_option_button.get_popup().connect("id_pressed", Callable(self, "_on_popup_menu_id_pressed"))
	# Unless the current scene is the main menu, disables the reset progress button
	if Global.game_controller.current_2d_scene.name != "MainMenu":
		reset_progress_button.disabled = true
	# Smooth appearance
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	# Updates last settings
	last_master_volume = UserSettings.master_volume
	last_music_volume = UserSettings.music_volume
	last_sfx_volume = UserSettings.sfx_volume
	last_gui_scale = UserSettings.gui_scale
	# Loads settings
	master_h_slider.value = UserSettings.master_volume
	music_h_slider.value = UserSettings.music_volume
	sfx_h_slider.value = UserSettings.sfx_volume
	# Selects current option by the index
	scale_option_button.select({0.8: 0, 1.0: 1, 1.2: 2, 1.4: 3}[UserSettings.gui_scale])

func _on_master_h_slider_value_changed(value: float) -> void:
	UserSettings.master_volume = value

func _on_music_h_slider_value_changed(value: float) -> void:
	UserSettings.music_volume = value

func _on_sfx_h_slider_value_changed(value: float) -> void:
	UserSettings.sfx_volume = value

func _on_scale_option_button_item_selected(index: int) -> void:
	UserSettings.gui_scale = float(scale_option_button.get_item_text(index))

func _on_scale_option_button_pressed() -> void:
	SoundManager.click.play()

func _on_popup_menu_id_pressed(_id: int) -> void:
	SoundManager.click.play()

func _on_reset_settings_button_pressed() -> void:
	SoundManager.click.play()
	master_h_slider.value = UserSettings.DEFAULT_MASTER_VOLUME
	music_h_slider.value = UserSettings.DEFAULT_MUSIC_VOLUME
	sfx_h_slider.value = UserSettings.DEFAULT_SFX_VOLUME
	scale_option_button.select({0.8: 0, 1.0: 1, 1.2: 2, 1.4: 3}[UserSettings.match_scale()])
	scale_option_button.emit_signal("item_selected", {0.8: 0, 1.0: 1, 1.2: 2, 1.4: 3}[UserSettings.match_scale()])

func _on_reset_progress_button_pressed() -> void:
	SoundManager.click.play()
	confirmation.visible = true
	confirmation.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(confirmation, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)

func _on_apply_button_pressed() -> void:
	SoundManager.click.play()
	# Update last settings
	if last_gui_scale != UserSettings.gui_scale:
		Global.game_controller.change_gui_scene("message", false, true)
		Global.game_controller.current_gui_scene.set_text("Сохранение... Нужен перезапуск! Игра выключится самостоятельно через 5 секунд")
		await get_tree().create_timer(5.0).timeout
		get_tree().quit()
	last_master_volume = UserSettings.master_volume
	last_music_volume = UserSettings.music_volume
	last_sfx_volume = UserSettings.sfx_volume
	last_gui_scale = UserSettings.gui_scale

func _on_cancel_button_pressed() -> void:
	SoundManager.click.play()
	UserSettings.master_volume = last_master_volume
	UserSettings.music_volume = last_music_volume
	UserSettings.sfx_volume = last_sfx_volume
	UserSettings.gui_scale = last_gui_scale
	# Load settings
	master_h_slider.value = UserSettings.master_volume
	music_h_slider.value = UserSettings.music_volume
	sfx_h_slider.value = UserSettings.sfx_volume
	scale_option_button.select({0.8: 0, 1.0: 1, 1.2: 2, 1.4: 3}[UserSettings.gui_scale])

func _on_close_button_pressed() -> void:
	close()

func _on_cancel_pressed() -> void:
	SoundManager.click.play()
	var tween = create_tween()
	tween.tween_property(confirmation, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	confirmation.visible = false

func _on_confirm_pressed() -> void:
	SoundManager.click.play()
	var tween = create_tween()
	tween.tween_property(confirmation, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	confirmation.visible = false
	for level in UserData.progress.keys():
		UserData.progress[level]["is_completed"] = false
		UserData.progress[level]["stars"] = 0
	var save = FileAccess.open(UserData.SAVE_PATH, FileAccess.WRITE)
	save.store_var(UserData.progress)
	Global.game_controller.change_gui_scene("message", false, true)
	Global.game_controller.current_gui_scene.set_text("Сохранение... Нужен перезапуск! Игра выключится самостоятельно через 5 секунд")
	await get_tree().create_timer(5.0).timeout
	get_tree().quit()

func close() -> void:
	SoundManager.click.play()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	# If settings weren't applied, cancel them
	# P.S. Nothing will change if they were
	UserSettings.master_volume = last_master_volume
	UserSettings.music_volume = last_music_volume
	UserSettings.sfx_volume = last_sfx_volume
	UserSettings.gui_scale = last_gui_scale
	queue_free()
