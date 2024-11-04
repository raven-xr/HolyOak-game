extends Control

# Scenes
@export var message_scene: PackedScene

# Nodes
@onready var master_h_slider = $"PanelContainer/VBoxContainer/Master Volume/Master HSlider"
@onready var music_h_slider = $"PanelContainer/VBoxContainer/Music Volume/Music HSlider"
@onready var sfx_h_slider = $"PanelContainer/VBoxContainer/SFX Volume/SFX HSlider"
@onready var scale_option_button = $"PanelContainer/VBoxContainer/GUI Scale/Scale OptionButton"

@onready var confirmation = $"PanelContainer/VBoxContainer/Data Reset/Reset Progress/Confirmation"

@onready var reset_progress = $"PanelContainer/VBoxContainer/Data Reset/Reset Progress"



# Common functions
func _ready():
	# Unless the current scene is the main menu, disable the reset progress button
	if get_tree().current_scene.name != "Main Menu":
		reset_progress.disabled = true
	# Load settings
	master_h_slider.value = UserSettings.master_volume
	music_h_slider.value = UserSettings.music_volume
	sfx_h_slider.value = UserSettings.sfx_volume
	scale_option_button.select({0.8: 0, 1.0: 1, 1.2: 2, 1.4: 3}[UserSettings.gui_scale])
	# Animate
	confirmation.visible = false
	confirmation.modulate = Color(1, 1, 1, 0)
	modulate = Color(1, 1, 1, 0)

func _on_visibility_changed():
	# Animate the appearance
	if visible:
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)



# Volume's functions
func _on_master_h_slider_value_changed(value):
	UserSettings.master_volume = value

func _on_music_h_slider_value_changed(value):
	UserSettings.music_volume = value

func _on_sfx_h_slider_value_changed(value):
	UserSettings.sfx_volume = value



# GUI's functions
func _on_scale_option_button_item_selected(index):
	UserSettings.gui_scale = float(scale_option_button.get_item_text(index))
	var new_message = message_scene.instantiate()
	new_message.text = 'Для применения масштабирования, необходима перезагрузка'
	add_child(new_message)


# Data Reset functions
func _on_reset_settings_pressed():
	master_h_slider.value = UserSettings.DEFAULT_MASTER_VOLUME
	music_h_slider.value = UserSettings.DEFAULT_MUSIC_VOLUME
	sfx_h_slider.value = UserSettings.DEFAULT_SFX_VOLUME
	scale_option_button.select({0.8: 0, 1.0: 1, 1.2: 2, 1.4: 3}[UserSettings.DEFAULT_GUI_SCALE])
	scale_option_button.emit_signal("item_selected", {0.8: 0, 1.0: 1, 1.2: 2, 1.4: 3}[UserSettings.DEFAULT_GUI_SCALE])

func _on_reset_progress_pressed():
	confirmation.visible = true
	var tween = create_tween()
	tween.tween_property(confirmation, "modulate", Color(1, 1, 1, 1), 0.1)

# Close button's functions
func _on_close_button_pressed():
	SoundManager.click.play()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	visible = false



# Confirmation's functions
func _on_cancel_pressed():
	var tween = create_tween()
	tween.tween_property(confirmation, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	confirmation.visible = false

func _on_confirm_pressed():
	var tween = create_tween()
	tween.tween_property(confirmation, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	confirmation.visible = false
	for level in UserData.level_data.keys():
		UserData.level_data[level]["is_completed"] = false
		UserData.level_data[level]["stars"] = 0
	var save = FileAccess.open(UserData.SAVE_PATH, FileAccess.WRITE)
	save.store_var(UserData.level_data)
	var new_message = message_scene.instantiate()
	new_message.text = 'Перезагрузка...'
	add_child(new_message)
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
