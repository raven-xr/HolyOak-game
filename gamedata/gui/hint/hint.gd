extends Control

@onready var panel_container = $PanelContainer
@onready var label = $PanelContainer/Label
@onready var texture_rect = $TextureRect
@onready var touch_screen_button = $TouchScreenButton

var can_be_pressed: bool = true
var text: String = ""

signal hidden_()

func _ready():
	# Scale
	scale = Vector2(UserSettings.gui_scale**2, UserSettings.gui_scale**2)
	# Animate
	flick_chevron_right()
	modulate = Color(1, 1, 1, 0)

func flick_chevron_right():
	await get_tree().create_timer(0.5).timeout
	texture_rect.visible = !texture_rect.visible
	flick_chevron_right()

func show_():
	label.text = text
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)
	await get_tree().create_timer(1.0).timeout
	touch_screen_button.shape.size = panel_container.size
	touch_screen_button.position.y = panel_container.size.y / 2

func hide_():
	touch_screen_button.shape.size = Vector2(0, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2)
	await tween.finished
	emit_signal("hidden_")

func close():
	hide_()
	await hidden_
	queue_free()

func _on_touch_screen_button_pressed():
	if can_be_pressed:
		SoundManager.click.play()
		hide_()
