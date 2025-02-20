extends Control



@export var message_scene: PackedScene



@onready var master_h_slider = $"PanelContainer/VBoxContainer/Master Volume/Master HSlider"
@onready var music_h_slider = $"PanelContainer/VBoxContainer/Music Volume/Music HSlider"
@onready var sfx_h_slider = $"PanelContainer/VBoxContainer/SFX Volume/SFX HSlider"
@onready var scale_option_button = $"PanelContainer/VBoxContainer/GUI Scale/Scale OptionButton"

@onready var confirmation = $"PanelContainer/VBoxContainer/Data Reset/Reset Progress Button/Confirmation"

@onready var reset_progress_button = $"PanelContainer/VBoxContainer/Data Reset/Reset Progress Button"



# Previous settings (will be used, if player didn't apply settings)
# Gets values when settings is opened
var last_master_volume: float = UserSettings.master_volume
var last_music_volume: float = UserSettings.music_volume
var last_sfx_volume: float = UserSettings.sfx_volume
var last_gui_scale: float = UserSettings.gui_scale




func _ready():
	# Scale
	scale = Vector2(UserSettings.gui_scale, UserSettings.gui_scale)
	# Connect signals
	scale_option_button.get_popup().connect("id_pressed", Callable(self, "_on_popup_menu_id_pressed"))
	# Unless the current scene is the main menu, disable the reset progress button
	if get_tree().current_scene.name != "Main Menu":
		reset_progress_button.disabled = true
	# Animate
	confirmation.visible = false
	confirmation.modulate = Color(1, 1, 1, 0)
	modulate = Color(1, 1, 1, 0)

func _on_visibility_changed():
	# Animate the appearance
	if visible:
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1)
		# Update last settings
		last_master_volume = UserSettings.master_volume
		last_music_volume = UserSettings.music_volume
		last_sfx_volume = UserSettings.sfx_volume
		last_gui_scale = UserSettings.gui_scale
		# Load settings
		master_h_slider.value = UserSettings.master_volume
		music_h_slider.value = UserSettings.music_volume
		sfx_h_slider.value = UserSettings.sfx_volume
		scale_option_button.select({0.8: 0, 1.0: 1, 1.2: 2, 1.4: 3}[UserSettings.gui_scale])
	else:
		# If settings weren't applied, cancel them
		# P.S. Nothing will change if they were
		UserSettings.master_volume = last_master_volume
		UserSettings.music_volume = last_music_volume
		UserSettings.sfx_volume = last_sfx_volume
		UserSettings.gui_scale = last_gui_scale



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

func _on_scale_option_button_pressed():
	SoundManager.click.play()

func _on_popup_menu_id_pressed(_id):
	SoundManager.click.play()


# Data Reset functions
func _on_reset_settings_button_pressed():
	SoundManager.click.play()
	master_h_slider.value = UserSettings.DEFAULT_MASTER_VOLUME
	music_h_slider.value = UserSettings.DEFAULT_MUSIC_VOLUME
	sfx_h_slider.value = UserSettings.DEFAULT_SFX_VOLUME
	scale_option_button.select({0.8: 0, 1.0: 1, 1.2: 2, 1.4: 3}[UserSettings.match_scale(OS.get_name())])
	scale_option_button.emit_signal("item_selected", {0.8: 0, 1.0: 1, 1.2: 2, 1.4: 3}[UserSettings.match_scale(OS.get_name())])

func _on_reset_progress_button_pressed():
	SoundManager.click.play()
	confirmation.visible = true
	var tween = create_tween()
	tween.tween_property(confirmation, "modulate", Color(1, 1, 1, 1), 0.1)

func _on_apply_button_pressed():
	SoundManager.click.play()
	# Update last settings
	if last_gui_scale != UserSettings.gui_scale:
		var new_message = message_scene.instantiate()
		new_message.text = 'Для полного применения масштабирования, необходима перезагрузка...'
		add_child(new_message)

	last_master_volume = UserSettings.master_volume
	last_music_volume = UserSettings.music_volume
	last_sfx_volume = UserSettings.sfx_volume
	last_gui_scale = UserSettings.gui_scale

func _on_cancel_button_pressed():
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



# Close button's functions
func _on_close_button_pressed():
	SoundManager.click.play()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	visible = false



# Confirmation's functions
func _on_cancel_pressed():
	SoundManager.click.play()
	var tween = create_tween()
	tween.tween_property(confirmation, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	confirmation.visible = false

func _on_confirm_pressed():
	SoundManager.click.play()
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
