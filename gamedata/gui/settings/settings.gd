extends NodeGUI

@onready var master_h_slider: HSlider = $"PanelContainer/VBoxContainer/Master Volume/Master HSlider"
@onready var music_h_slider: HSlider = $"PanelContainer/VBoxContainer/Music Volume/Music HSlider"
@onready var sfx_h_slider: HSlider = $"PanelContainer/VBoxContainer/SFX Volume/SFX HSlider"
@onready var scale_option_button: OptionButton = $"PanelContainer/VBoxContainer/GUI Scale/Scale OptionButton"
@onready var reset_progress_button: Button = $"PanelContainer/VBoxContainer/Data Reset/Reset Progress Button"
@onready var popup_menu: PopupMenu = scale_option_button.get_popup()

# Previous settings (will be used, if player didn't apply settings)
# Gets values when settings is opened
var last_master_volume: float = UserSettings.master_volume
var last_music_volume: float = UserSettings.music_volume
var last_sfx_volume: float = UserSettings.sfx_volume
var last_gui_scale: float = UserSettings.gui_scale

func _ready() -> void:
	popup_menu.connect("id_pressed", Callable(self, "_on_popup_menu_id_pressed"))
	# Unless the current scene is the main menu, disables the reset progress button
	if Global.game_controller.current_2d_scene.name != "MainMenu":
		reset_progress_button.disabled = true
		scale_option_button.disabled = true
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
	scale_option_button.select({0.5: 0, 0.6: 1, 0.7: 2, 0.8: 3, 0.9: 4, 1.0: 5}[UserSettings.gui_scale])

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
	scale_option_button.select({0.5: 0, 0.6: 1, 0.7: 2, 0.8: 3, 0.9: 4, 1.0: 5}[UserSettings.match_scale()])
	scale_option_button.emit_signal("item_selected", {0.5: 0, 0.6: 1, 0.7: 2, 0.8: 3, 0.9: 4, 1.0: 5}[UserSettings.match_scale()])

func _on_reset_progress_button_pressed() -> void:
	SoundManager.click.play()
	Global.game_controller.change_gui_scene("confirmation", false, true)
	can_be_closed = false
	var confirmation: NodeGUI = Global.game_controller.current_gui_scene
	confirmation.connect("confirmed", Callable(self, "_on_confirmed"))
	confirmation.connect("canceled", Callable(self, "_on_canceled"))

func _on_apply_button_pressed() -> void:
	SoundManager.click.play()
	# Update last settings
	if last_gui_scale != UserSettings.gui_scale:
		Global.game_controller.change_gui_scene("message", false, true)
		Global.game_controller.current_gui_scene.set_text("Сохранение... Нужен перезапуск! Игра выключится самостоятельно через 5 секунд")
		get_viewport().gui_disable_input = true # Makes player unable to interact with the GUI
		await get_tree().create_timer(5.0).timeout
		get_tree().quit()
	last_master_volume = UserSettings.master_volume
	last_music_volume = UserSettings.music_volume
	last_sfx_volume = UserSettings.sfx_volume
	last_gui_scale = UserSettings.gui_scale

func _on_cancel_button_pressed() -> void:
	SoundManager.click.play()
	reset()

func _on_close_button_pressed() -> void:
	SoundManager.click.play()
	reset()
	close()

func _on_canceled() -> void:
	# Confirmation canceled
	SoundManager.click.play()
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.15)
	can_be_closed = true

func _on_confirmed() -> void:
	# Confirmation... confirmed?
	DirAccess.remove_absolute(UserData.SAVE_PATH)
	Global.game_controller.change_gui_scene("message", false, true)
	Global.game_controller.current_gui_scene.set_text("Сохранение... Нужен перезапуск! Игра выключится самостоятельно через 5 секунд")
	get_viewport().gui_disable_input = true # Makes player not able to interact with the GUI
	await get_tree().create_timer(5.0).timeout
	get_tree().quit()

func reset() -> void:
	# If settings weren't applied, cancel them
	# P.S. Nothing will change if they were
	UserSettings.master_volume = last_master_volume
	UserSettings.music_volume = last_music_volume
	UserSettings.sfx_volume = last_sfx_volume
	UserSettings.gui_scale = last_gui_scale
	# Load settings
	master_h_slider.value = UserSettings.master_volume
	music_h_slider.value = UserSettings.music_volume
	sfx_h_slider.value = UserSettings.sfx_volume
	scale_option_button.select({0.5: 0, 0.6: 1, 0.7: 2, 0.8: 3, 0.9: 4, 1.0: 5}[UserSettings.gui_scale])

func close() -> void:
	reset()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)
	await tween.finished
	# Remove the value of the "current_gui_scene" variable if this NodeGUI is the current_gui_scene
	if Global.game_controller.current_gui_scene == self:
		Global.game_controller.current_gui_scene = null
	queue_free()
