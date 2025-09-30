extends PanelContainer

@onready var freeze_item: Item = $HBoxContainer/FreezeItem

var freeze_item_count: int = 0:
	set(value):
		$"HBoxContainer/Freeze Count".text = str(value)
		freeze_item_count = value

func _on_freeze_item_pressed() -> void:
	if freeze_item_count > 0:
		if not freeze_item.is_selected:
			freeze_item.select()
		else:
			freeze_item.deselect()
	else:
		Global.game_controller.change_gui_scene("message")
		Global.game_controller.current_gui_scene.set_text("У вас нет заклинаний заморозки")
