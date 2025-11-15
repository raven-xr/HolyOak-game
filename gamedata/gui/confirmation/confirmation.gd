extends NodeGUI

signal confirmed()
signal canceled()

func _ready() -> void:
	Global.game_controller.current_2d_scene.set_process_mode(Node.PROCESS_MODE_DISABLED)

func _on_confirm_button_pressed() -> void:
	SoundManager.click.play()
	confirmed.emit()
	Global.game_controller.current_2d_scene.set_process_mode(Node.PROCESS_MODE_INHERIT)
	close()

func _on_cancel_button_pressed() -> void:
	SoundManager.click.play()
	canceled.emit()
	Global.game_controller.current_2d_scene.set_process_mode(Node.PROCESS_MODE_INHERIT)
	close()

func set_text(text: String) -> void:
	$PanelContainer/VBoxContainer/Label.text = text
