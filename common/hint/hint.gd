extends Node2D

@onready var panel_container = $PanelContainer
@onready var label = $PanelContainer/Label
@onready var texture_rect = $TextureRect
@onready var touch_screen_button = $TouchScreenButton

var can_be_closed: bool = true
var text: String = ''

func _ready():
	label.text = text
	await get_tree().create_timer(1.0).timeout
	touch_screen_button.shape.size.y = panel_container.size.y
	touch_screen_button.position.y = panel_container.size.y / 2
	flick_chevron_right()

func flick_chevron_right():
	await get_tree().create_timer(0.5).timeout
	texture_rect.visible = !texture_rect.visible
	flick_chevron_right()

func _on_touch_screen_button_pressed():
	if can_be_closed:
		SoundManager.click.play()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.3)
		tween.connect("finished", queue_free)
