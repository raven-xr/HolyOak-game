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



func _on_enemy_detected(enemy):
	if new_direction:
		enemy.view_direction = new_direction
	if next_roadpoint:
		enemy.next_roadpoint_position = next_roadpoint.position
	else:
		enemy.attack()
