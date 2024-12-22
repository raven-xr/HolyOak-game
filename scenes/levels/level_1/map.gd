extends Node2D

@onready var bushes = $Bushes
@onready var trees = $Trees

func _ready():
	# Scale trees and bushes
	for bush in bushes.get_children():
		var scale_ = randf_range(0.8, 1.1)
		bush.scale = Vector2(scale_, scale_)
	for tree in trees.get_children():
		var scale_ = randf_range(1.4, 1.6)
		tree.scale = Vector2(scale_, scale_)
