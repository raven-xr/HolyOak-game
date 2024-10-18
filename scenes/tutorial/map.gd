extends Node2D

@onready var bushes = $Bushes
@onready var trees = $Trees

func _ready():
	# Scale trees and bushes
	for bush in bushes.get_children():
		var scale_ = float(randi_range(80, 110)) / 100
		bush.scale = Vector2(scale_, scale_)
	for tree in trees.get_children():
		var scale_ = float(randi_range(140, 160)) / 100
		tree.scale = Vector2(scale_, scale_)
