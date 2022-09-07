extends Node2D
class_name SuperChartGrid

var super_chart

var view_range_v := Vector2()

var index_dic_h := {}

var index_reach_left := 0.0
var index_reach_right := 0.0

var index_reach_top := 0.0
var index_reach_bottom := 0.0

var view_rect := Rect2()

var grid_vertical_count : int = 10
var grid_line_width := 2.0
var grid_color := Color.white

func _draw():
	if index_reach_left == 0 || index_reach_right == 0:
		return
	index_dic_h.clear()
	var _h_index : int = ceil(index_reach_left)
	while _h_index <= index_reach_right:
		var percent : float = (_h_index - index_reach_left) / (index_reach_right - index_reach_left)
		var pos_x : float = view_rect.position.x + view_rect.size.x * percent
		index_dic_h[_h_index] = percent
		draw_line(
			Vector2(pos_x, view_rect.position.y) - view_rect.position,
			Vector2(pos_x, view_rect.position.y + view_rect.size.y) - view_rect.position,
			grid_color,
			grid_line_width * super_chart.zoom
		)
		
		_h_index += 1
	
	
	for i in grid_vertical_count:
		var pos_y : float = view_rect.position.y + float(i) / grid_vertical_count * view_rect.size.y
		draw_line(
			Vector2(view_rect.position.x, pos_y) - view_rect.position,
			Vector2(view_rect.position.x + view_rect.size.x, pos_y) - view_rect.position,
			grid_color,
			grid_line_width * super_chart.zoom
		)
	
#	var _v_index : int = ceil(index_reach_top)
#	while _v_index <= index_reach_bottom:
#		var percent : float = (_v_index - index_reach_top) / (index_reach_bottom - index_reach_top)
#		var pos_y : float = view_rect.position.y + view_rect.size.y * percent
#		draw_line(
#			Vector2(view_rect.position.x, pos_y) - view_rect.position,
#			Vector2(view_rect.position.x + view_rect.size.x, pos_y) - view_rect.position,
#			grid_color,
#			grid_line_width * super_chart.zoom
#		)
#		_v_index += 1
		
#	var _v_rate := -1.0
#	while _v_rate <= 1.0:
#		draw_line(
#			Vector2(view_rect.position.x, )
#		)
#		_v_rate += rate_vertical_period
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init_grid(
	_super_chart,
	_grid_vertical_count := grid_vertical_count,
	_grid_line_width := grid_line_width,
	_grid_color := grid_color
):
	
	super_chart = _super_chart
	grid_vertical_count = _grid_vertical_count
	grid_line_width = _grid_line_width
	grid_color = _grid_color
	pass

func process():
	view_rect = super_chart.chart_view_rect
	
	index_reach_left = view_rect.position.x / super_chart.interval_column
	index_reach_right = (view_rect.position.x + view_rect.size.x) / super_chart.interval_column
	
	
	index_reach_top = (view_rect.position.y + super_chart.position_top) / (super_chart.position_top - super_chart.position_bottom)
	index_reach_bottom = (view_rect.position.y + view_rect.size.y + super_chart.position_top) / (super_chart.position_top - super_chart.position_bottom)
	view_range_v = Vector2(-index_reach_bottom + 1, -index_reach_top + 1)
#
#	index_reach_top = index_reach_top * grid_value_unit
#	index_reach_bottom = index_reach_bottom * grid_value_unit


#	index_reach_bottom = (view_rect.position.y + view_rect.size.y - super_chart.position_top) / (super_chart.position_top - super_chart.position_bottom)
#
#	index_reach_top = (index_reach_top + 1.0) / 2.0
#	index_reach_bottom = (index_reach_bottom + 1.0) / 2.0
#
#	print("%f to %f" % [index_reach_top, index_reach_bottom])
	
	update()
	pass
