extends Node2D
class_name SuperChartXLabel
var super_chart
var font : Font
var color := Color.white

var view_size := Vector2()
var index_dic_h := {}

func _draw():
	for i in index_dic_h:
		if i >= 0 && i < super_chart.headers.size():
			var pos_x : float = view_size.x * index_dic_h[i]
			var text : String = super_chart.headers[i]
			draw_string(
				font,
				Vector2(pos_x, view_size.y / 2),
				text,
				color
			)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init_x_label(
	_super_chart,
	_font : Font,
	_color := color
):
	super_chart = _super_chart
	font = _font
	color = _color
	pass

func process():
	update()
	pass
