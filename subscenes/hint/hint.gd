extends PanelContainer

@onready var label = $Label

# These values are given by the parent
var text: String

func _ready():
	label.text = text
