extends Node2D
class_name Spell

var is_placed: bool = false:
	set(value):
		is_placed = value
		if value:
			set_physics_process(false)
			for child: Node in get_children():
				child.set_process_mode(Node.PROCESS_MODE_INHERIT)
			placed.emit()

signal placed()

func _ready() -> void:
	# All children have to wait until the spell is placed
	for child: Node in get_children():
		child.set_process_mode(Node.PROCESS_MODE_DISABLED)

func _physics_process(_delta: float) -> void:
	# Not placed spell is following the cursor
	global_position = get_global_mouse_position()
	if Input.is_action_just_released("ui_accept"):
		is_placed = true
