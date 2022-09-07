extends WindowDialog

onready var _LabelTitle = $VBoxContainer/LabelTitle
onready var _LabelContent = $VBoxContainer/LabelContent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activate(title : String, color : Color, header : String, value : String):
	_LabelTitle.modulate = color
	_LabelTitle.text = title
	_LabelContent.text = "%s : %s" % [
		header, value
	]
