extends HBoxContainer

var point_type2texture := {
	SuperChartDataPoint.POINT_TYPE.CIRCLE : preload("res://addons/DrunkBull.SuperChart/assets/art/circle.png"),
	SuperChartDataPoint.POINT_TYPE.RECT : preload("res://addons/DrunkBull.SuperChart/assets/art/rect.png"),
	SuperChartDataPoint.POINT_TYPE.TRIANGLE : preload("res://addons/DrunkBull.SuperChart/assets/art/triangle.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_font(_font : Font):
	$Label.set("custom_fonts/font", _font)

func set_point_type(_point_type : int):
	$TextureRect.texture = point_type2texture.get(_point_type)
	pass

func set_title(_text : String):
	$Label.text = _text

func set_color(_color : Color):
	modulate = _color
