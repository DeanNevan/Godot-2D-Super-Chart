extends Node2D
class_name SuperChartDataLine

onready var _DataPoints = $DataPoints

var scene_data_point : PackedScene = preload("res://addons/DrunkBull.SuperChart/src/main/SuperChartDataPoint/SuperChartDataPoint.tscn")

var super_chart

var line_index := 0
var point_type := 0
var line_width := 1.0
var data := []
var line_color := Color.white
var point_color := Color.white
var point_size := Vector2(20, 20)

func _draw():
	for i in _DataPoints.get_child_count() - 1:
		var data_point : SuperChartDataPoint = _DataPoints.get_child(i)
		var data_point_next : SuperChartDataPoint = _DataPoints.get_child(i + 1)
		var draw_low_alpha : bool = is_instance_valid(super_chart.focusing_point) || is_instance_valid(super_chart.viewing_point)
		draw_line(
			data_point.position_in_view,
			data_point_next.position_in_view,
			line_color if !draw_low_alpha else Color(
				line_color.r,
				line_color.g,
				line_color.b,
				line_color.a / 4
			),
			line_width * super_chart.zoom,
			true
		)
		
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init_data_line(
		_super_chart,
		_line_index : int, 
		_data : Array, 
		_line_width : float, 
		_line_color : Color, 
		_point_color : Color, 
		_point_type : int, 
		_point_size : Vector2
	):
		super_chart = _super_chart
		line_index = _line_index
		data = _data
		line_width = _line_width
		line_color = _line_color
		point_type = _point_type
		point_color = _point_color
		point_size = _point_size
		
		for i in _DataPoints.get_children():
			i.queue_free()
		for i in data.size():
			var pos := Vector2(i * super_chart.interval_column, 0)
			pos.y = super_chart.position_bottom + (super_chart.position_top - super_chart.position_bottom) * ((data[i] - super_chart.value_bottom) / (super_chart.value_top - super_chart.value_bottom))
			pos.y = - pos.y
			var new_data_point : SuperChartDataPoint = scene_data_point.instance()
			_DataPoints.add_child(new_data_point)
			new_data_point.init_data_point(
				self,
				super_chart.headers[i],
				data[i],
				i,
				point_type,
				pos,
				point_size,
				point_color
			)

func process():
	for i in _DataPoints.get_children():
		i.process()
	update()
	pass
