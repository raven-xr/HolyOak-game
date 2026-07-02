extends NodeGUI

func set_head(text: String) -> void:
	$VBoxContainer/Head/Label.text = text

func set_description(text: String) -> void:
	$VBoxContainer/Description/Label.text = text

func set_stats_text(text: String) -> void:
	$VBoxContainer/StatsText/Label.text = text

func _on_close_button_pressed() -> void:
	SoundManager.click.play()
	close()
