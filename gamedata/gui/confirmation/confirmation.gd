extends NodeGUI

signal confirmed()
signal canceled()

func _on_confirm_button_pressed() -> void:
	SoundManager.click.play()
	confirmed.emit()
	close()

func _on_cancel_button_pressed() -> void:
	SoundManager.click.play()
	canceled.emit()
	close()

func set_text(text: String) -> void:
	$PanelContainer/VBoxContainer/Label.text = text
