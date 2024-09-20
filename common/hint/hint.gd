extends PanelContainer

@onready var label = $Label

# These variables are given by the parent
var text: String = ''

func _ready():
	label.text = text
