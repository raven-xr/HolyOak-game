extends CanvasLayer

@onready var label = $PanelContainer/Label

# These variables are given by the parent
var text: String = ''

func _ready():
	label.text = text
