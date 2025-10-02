extends PanelContainer

@onready var freeze_item: Item = $HBoxContainer/FreezeItem
@onready var heal_item: Item = $HBoxContainer/HealItem

var freeze_item_count: int = 0:
	set(value):
		$"HBoxContainer/Freeze Count".text = str(value)
		freeze_item_count = value
var heal_item_count: int = 0:
	set(value):
		$"HBoxContainer/Heal Count".text = str(value)
		heal_item_count = value

func _on_freeze_item_pressed() -> void:
	press_item(freeze_item, freeze_item_count)

func _on_heal_item_pressed() -> void:
	press_item(heal_item, heal_item_count)

func press_item(item: Item, count: int) -> void:
	if count > 0:
		if not item.is_selected:
			for item_ in [freeze_item, heal_item]:
				if item_.is_selected:
					item_.deselect()
			item.select()
		else:
			item.deselect()
	else:
		Global.game_controller.change_gui_scene("message")
		Global.game_controller.current_gui_scene.set_text("У вас нет этого предмета!")
