extends Node2D
class_name SuperChartYLabel
var super_chart
var font : Font
var color := Color.white
var pad_decimals_y_label := 1
var view_size := Vector2()
var view_range_v := Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	for i in super_chart.grid_vertical_count:
		var pos_y : float = view_size.y / super_chart.grid_vertical_count * i
		var percent : float = view_range_v.x + (super_chart.grid_vertical_count - i) * (view_range_v.y - view_range_v.x) / super_chart.grid_vertical_count
		var value : float = super_chart.value_bottom + percent * (super_chart.value_top - super_chart.value_bottom)
		var text : String = str(value).pad_decimals(pad_decimals_y_label)
		draw_string(
			font,
			Vector2(0, pos_y),
			text,
			color
		)

func init_y_label(
	_super_chart,
	_font : Font,
	_color := color,
	_pad_decimals_y_label := pad_decimals_y_label
):
	super_chart = _super_chart
	font = _font
	color = _color
	pad_decimals_y_label = _pad_decimals_y_label
	pass

func process():
	update()
	pass
