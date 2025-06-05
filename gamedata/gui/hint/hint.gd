extends NodeGUI

@onready var panel_container: PanelContainer = $PanelContainer
@onready var label: Label = $PanelContainer/Label
@onready var texture_rect: TextureRect = $TextureRect
@onready var touch_screen_button: TouchScreenButton = $TouchScreenButton

var can_be_skipped: bool = true
var text: String = ""

signal hidden_()

func _ready() -> void:
	scale *= UserSettings.gui_scale # Scales the hint even more
	flick_chevron_right()

func flick_chevron_right() -> void:
	await get_tree().create_timer(0.5).timeout
	texture_rect.visible = not texture_rect.visible
	flick_chevron_right()

func show_() -> void:
	label.text = text
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.15)
	await tween.finished
	resize()
	touch_screen_button.visible = true

func hide_() -> void:
	touch_screen_button.visible = false
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)
	await tween.finished
	hidden_.emit()

func resize() -> void:
	touch_screen_button.shape.size = panel_container.size
	touch_screen_button.position.y = panel_container.size.y / 2

func _on_touch_screen_button_pressed() -> void:
	if can_be_skipped:
		SoundManager.click.play()
		hide_()
