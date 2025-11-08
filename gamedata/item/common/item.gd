extends Button
class_name Item

## What happens after this item is seleceted
@export_group("Indication")
@export var glow: bool = true

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var v_box_container: VBoxContainer = $VBoxContainer

@onready var info_button: Button = $VBoxContainer/InfoButton

@onready var info: Control = $VBoxContainer/InfoButton/Info

@onready var close_button: Button = $VBoxContainer/InfoButton/Info/CloseButton

var is_selected: bool = false

signal selected()
signal used()
signal deselected()

func _ready() -> void:
	v_box_container.modulate.a = 0.0
	point_light_2d.color.a = 0.0

func select() -> void:
	point_light_2d.enabled = true
	var tween = create_tween().set_parallel()
	tween.tween_property(point_light_2d, "color:a", 1.0, 0.15)
	v_box_container.visible = true
	tween.tween_property(v_box_container, "modulate:a", 1.0, 0.15)
	is_selected = true
	selected.emit()

func deselect() -> void:
	disabled = true
	var tween = create_tween().set_parallel()
	tween.tween_property(point_light_2d, "color:a", 0.0, 0.15)
	tween.tween_property(v_box_container, "modulate:a", 0.0, 0.15)
	is_selected = false
	deselected.emit()
	await tween.finished
	disabled = false
	point_light_2d.enabled = false
	v_box_container.visible = false

func _on_pressed() -> void:
	SoundManager.click.play()

func _on_use_button_pressed() -> void:
	SoundManager.click.play()
	var tween = create_tween().set_parallel()
	tween.tween_property(point_light_2d, "color:a", 0.0, 0.15)
	tween.tween_property(v_box_container, "modulate:a", 0.0, 0.15)
	is_selected = false
	use()
	await tween.finished
	point_light_2d.enabled = false
	v_box_container.visible = false

func use() -> void:
	used.emit()

func _on_info_button_pressed() -> void:
	SoundManager.click.play()
	info.visible = true
	close_button.disabled = false
	var tween = create_tween()
	tween.tween_property(info, "modulate:a", 1.0, 0.15)
	info_button.disabled = true

func _on_close_button_pressed() -> void:
	SoundManager.click.play()
	close_button.disabled = true
	var tween = create_tween()
	tween.tween_property(info, "modulate:a", 0.0, 0.15)
	await tween.finished
	info.visible = false
	info_button.disabled = false
