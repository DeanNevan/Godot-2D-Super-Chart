extends Node2D
class_name SuperChartDataPoint

enum POINT_TYPE {
	CIRCLE,
	RECT,
	TRIANGLE
}
var point_type : int = POINT_TYPE.CIRCLE

var point_type2texture := {
	POINT_TYPE.CIRCLE : preload("res://addons/DrunkBull.SuperChart/assets/art/circle.png"),
	POINT_TYPE.RECT : preload("res://addons/DrunkBull.SuperChart/assets/art/rect.png"),
	POINT_TYPE.TRIANGLE : preload("res://addons/DrunkBull.SuperChart/assets/art/triangle.png"),
}

var super_chart
var super_chart_data_line

var position_in_view := Vector2()
var position_in_viewport := Vector2()
var is_in_view := false

var header := ""
var value
var index := 0
var point_position := Vector2()
var point_size := Vector2(20, 20)
var point_modulate := Color.white

var rect_point := Rect2()

func _draw():
	if is_in_view:
		var _zoomed_point_size = point_size * super_chart.zoom
		rect_point = Rect2(position_in_view - _zoomed_point_size / 2, _zoomed_point_size)
		var draw_low_alpha : bool = (
			(is_instance_valid(super_chart.focusing_point) && super_chart.focusing_point != self) || 
			(is_instance_valid(super_chart.viewing_point)  && super_chart.viewing_point  != self)
		)
		draw_texture_rect(
			point_type2texture[point_type], 
			rect_point,
			false,
			point_modulate if !draw_low_alpha else Color(
				point_modulate.r,
				point_modulate.g,
				point_modulate.b,
				point_modulate.a / 4
			)
		)

func init_data_point(
		_super_chart_data_line,
		_header : String,
		_value,
		_index : int,
		_point_type := point_type,
		_point_position := point_position,
		_point_size := point_size,
		_point_modulate := point_modulate
	):
		super_chart = _super_chart_data_line.super_chart
		super_chart_data_line = _super_chart_data_line
		header = _header
		value = _value
		index = _index
		point_type = _point_type
		point_position = _point_position
		point_size = _point_size
		point_modulate = _point_modulate

func process():
	var chart_view_rect : Rect2 = super_chart.chart_view_rect
	if chart_view_rect.has_point(point_position):
		is_in_view = true
	else:
		is_in_view = false
	var _rate_x : float = (point_position.x - chart_view_rect.position.x) / chart_view_rect.size.x
	var _rate_y : float = (point_position.y - chart_view_rect.position.y) / chart_view_rect.size.y
	position_in_view = point_position - chart_view_rect.position
	update()
	if is_in_view:
		if rect_point.has_point(super_chart.mouse_pos_in_chart):
			super_chart.focus_point(self)
		else:
			super_chart.unfocus_point(self)
#	position_in_view = Vector2(
#		index * super_chart.interval_column,
#
#	)
#	var view_rect : Rect2 = super_chart.view_rect
	pass

