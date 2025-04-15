extends Node

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		$"../User Interface/Menu Button".pressed.emit()
