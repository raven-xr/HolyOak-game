extends Control
class_name NodeGUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close()

func close() -> void:
	animation_player.play("Disappearance")
	await animation_player.animation_finished
	# Remove the value of the "current_gui_scene" variable if this NodeGUI is the current_gui_scene
	if Global.game_controller.current_gui_scene == self:
		Global.game_controller.current_gui_scene = null
	queue_free()
