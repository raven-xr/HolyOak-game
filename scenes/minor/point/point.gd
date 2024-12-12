extends Area2D



## Left the field empty if you don't want to change the direction of the body[br]
## U - Up, U-L - Up-left[br]
## L - Left[br]
## D - Down, D-L - Down-left[br]
## R - Right
@export var new_direction: String
## Defines the next roadpoint of the entered character
## Left the field empty if this is the last roadpoint
@export var next_roadpoint: Area2D



func _on_body_entered(body):
	# If the character doesn't follow the parent road, then skip him
	if get_parent().get_parent() != body.get_parent():
		return
	
	if next_roadpoint:
		body.next_roadpoint_position = next_roadpoint.position
		if new_direction:
			body.direction = new_direction
	else:
		body.attack()
