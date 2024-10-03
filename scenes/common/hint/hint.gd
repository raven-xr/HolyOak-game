extends Node2D

@onready var panel_container = $PanelContainer
@onready var label = $PanelContainer/Label
@onready var texture_rect = $TextureRect
@onready var touch_screen_button = $TouchScreenButton

var can_be_closed: bool = true
var text: String = ""

func _ready():
	modulate = Color(1, 1, 1, 0)
	flick_chevron_right()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)
	label.text = text
	await get_tree().create_timer(1.0).timeout
	touch_screen_button.shape.size = panel_container.size
	touch_screen_button.position.y = panel_container.size.y / 2

func flick_chevron_right():
	await get_tree().create_timer(0.5).timeout
	texture_rect.visible = !texture_rect.visible
	flick_chevron_right()

func _on_touch_screen_button_pressed():
	if can_be_closed:
		close()

func close():
	SoundManager.click.play()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2)
	tween.connect("finished", queue_free)
	touch_screen_button.shape.size = Vector2(0, 0)
