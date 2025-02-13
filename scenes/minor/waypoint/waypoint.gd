extends Area2D



## Left the field empty if you don't want to change the direction of the body[br]
## U - Up, U-L - Up-left, U-R - Up-right[br]
## L - Left[br]
## D - Down, D-L - Down-left, D-R - Down-right[br]
## R - Right
@export var new_direction: String
## Defines the next roadpoint of the entered character
## Left the field empty if this is the last roadpoint
@export var next_roadpoint: Area2D



func _on_enemy_detected(pivot: Area2D):
	var enemy: Enemy = pivot.get_parent()
	# enemy.get_parent() -> the Road node
	# get_parent().get_parent() -> the Road node
	if enemy.get_parent() != get_parent().get_parent(): return
	# If an enemy & a waypoint belong to different roads, then
	# Ignore him
	if new_direction:
		enemy.view_direction = new_direction
	if next_roadpoint:
		enemy.next_roadpoint_position = next_roadpoint.position
	else:
		enemy.attack()
