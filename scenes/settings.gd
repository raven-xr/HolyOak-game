extends CanvasLayer

# Nodes
@onready var control = $Control

@onready var master_h_slider = $"Control/PanelContainer/VBoxContainer/Master Volume/Master HSlider"
@onready var music_h_slider = $"Control/PanelContainer/VBoxContainer/Music Volume/Music HSlider"
@onready var sfx_h_slider = $"Control/PanelContainer/VBoxContainer/SFX Volume/SFX HSlider"



# Common functions
func _ready():
	master_h_slider.value = UserSettings.master_volume
	music_h_slider.value = UserSettings.music_volume
	sfx_h_slider.value = UserSettings.sfx_volume
	control.modulate = Color(1, 1, 1, 0)

func _on_visibility_changed():
	# Animate the appearance
	if visible:
		var tween = create_tween()
		tween.tween_property(control, "modulate", Color(1, 1, 1, 1), 0.1)



# Volume's functions
func _on_master_h_slider_value_changed(value):
	UserSettings.master_volume = value

func _on_music_h_slider_value_changed(value):
	UserSettings.music_volume = value

func _on_sfx_h_slider_value_changed(value):
	UserSettings.sfx_volume = value



# Close button's functions
func _on_close_button_pressed():
	SoundManager.click.play()
	var tween = create_tween()
	tween.tween_property(control, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	visible = false
