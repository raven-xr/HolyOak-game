extends CanvasLayer

# Nodes
@onready var control = $Control

@onready var master_h_slider = $"Control/PanelContainer/VBoxContainer/Master Volume/Master HSlider"
@onready var music_h_slider = $"Control/PanelContainer/VBoxContainer/Music Volume/Music HSlider"
@onready var sfx_h_slider = $"Control/PanelContainer/VBoxContainer/SFX Volume/SFX HSlider"

# Buses
var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")



# Common functions
func _ready():
	master_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	music_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	sfx_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
	control.modulate = Color(1, 1, 1, 0)

func _on_visibility_changed():
	# Animate the appearance
	if visible:
		var tween = create_tween()
		tween.tween_property(control, "modulate", Color(1, 1, 1, 1), 0.1)



# Volume's functions
func _on_master_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func _on_music_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

func _on_sfx_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))



# Close button's functions
func _on_close_button_pressed():
	SoundManager.click.play()
	var tween = create_tween()
	tween.tween_property(control, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	visible = false
