extends CanvasLayer

# Nodes
@onready var control = $Control



# Common functions
func _ready():
	control.modulate = Color(1, 1, 1, 0)

func _on_visibility_changed():
	# Animate the appearance
	if visible:
		var tween = create_tween()
		tween.tween_property(control, "modulate", Color(1, 1, 1, 1), 0.1)



# Volume's functions
func _on_master_bus_value_changed(value):
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, value)

func _on_music_bus_value_changed(value):
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, value)

func _on_sfx_bus_value_changed(value):
	var sfx_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus, value)



# Close button's functions
func _on_close_button_pressed():
	SoundManager.click.play()
	var tween = create_tween()
	tween.tween_property(control, "modulate", Color(1, 1, 1, 0), 0.1)
	await tween.finished
	visible = false
