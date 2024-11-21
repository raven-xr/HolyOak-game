extends Area2D

@export var direction: String = "D"

func _on_area_entered(area):
	area.get_parent().direction = direction
