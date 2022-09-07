extends Control
class_name SuperChart

onready var _ViewportXLabel = $ViewportXLabel
onready var _ViewportYLabel = $ViewportYLabel
onready var _SuperChartXLabel = $ViewportXLabel/SuperChartXLabel
onready var _SuperChartYLabel = $ViewportYLabel/SuperChartYLabel

onready var _Viewport = $Viewport
onready var _DataLines = $Viewport/DataLines
onready var _SuperChartGrid = $Viewport/SuperChartGrid

onready var _ContainerYLabel = $VBoxContainer/HBoxContainer/ContainerYLabel
onready var _ContainerXLabel = $VBoxContainer/HBoxContainer2/ContainerXLabel
onready var _ContainerChart = $VBoxContainer/HBoxContainer/ContainerChart

onready var _ListLineTitle = $VBoxContainer/HBoxContainer2/ContainerLineTitle/ScrollContainer/ListLineTitle

onready var _WindowViewData = $WindowViewData

var scene_data_line : PackedScene = preload("res://addons/DrunkBull.SuperChart/src/main/SuperChartDataLine/SuperChartDataLine.tscn")

export (String) var element_delimiter := ","

export (String, "\\n") var row_delimiter := "\\n"

export (float, 10.0, 1000.0) var interval_column := 200.0

export (float, 0.0, 10.0) var line_width = 4.0
export (Vector2) var point_size = Vector2(20, 20)

export (PoolColorArray) var pool_point_color := PoolColorArray([Color.blue, Color.green, Color.orange])
export (PoolColorArray) var pool_line_color := PoolColorArray([Color.darkblue, Color.darkgreen, Color.darkorange])
export (PoolStringArray) var pool_point_type := PoolStringArray(["circle", "rect", "triangle"])

export (float) var position_top := 200.0
export (float) var position_bottom := -200.0

export (int, 2, 50) var grid_vertical_count := 10
export (Color) var grid_color := Color(1.0, 1.0, 1.0, 0.25)
export (float, 0.0, 10.0) var grid_line_width := 2.0
export (Color) var grid_label_color := Color(1.0, 1.0, 1.0, 0.5)

export (Font) var font_x_label = Control.new().get_font("font")
export (Color) var color_x_label = Color.white
export (Font) var font_y_label = Control.new().get_font("font")
export (Color) var color_y_label = Color.white

export (int, 0, 5) var pad_decimals_y_label = 1

export (Font) var font_line_title_info = Control.new().get_font("font")

export (float, 0.1, 10) var strength_move := 1.0
export (float, 0.1, 10) var strength_zoom := 2.5
export (float, 0.01, 100) var zoom_min := 0.1
export (float, 0.01, 100) var zoom_max := 10

var focusing_point : SuperChartDataPoint

var viewing_point : SuperChartDataPoint
var dragging := false

var scene_line_title : PackedScene = preload("res://addons/DrunkBull.SuperChart/src/main/LineTitle/LineTitle.tscn")

var value_top := 0.0
var value_bottom := 0.0

var index_point_top := Vector2()
var index_point_bottom := Vector2()

var data_string := ""
var headers := []
var data := []
var line_title := []

var viewport_size := Vector2(500, 500) setget set_viewport_size

var margin_rect := Rect2()

var chart_view_rect := Rect2()

var mouse_pos_in_chart := Vector2()

var zoom := 1.0
var pivot := Vector2()

func _input(event):
	if event is InputEventMouseButton:
		if _ContainerChart.get_rect().has_point(event.position):
			if event.button_index == BUTTON_LEFT:
				dragging = event.pressed
				if is_instance_valid(focusing_point):
					view_point(focusing_point)
			if event.button_index == BUTTON_WHEEL_UP:
				change_zoom(zoom * (1 - strength_zoom / 100))
			if event.button_index == BUTTON_WHEEL_DOWN:
				change_zoom(zoom * (1 + strength_zoom / 100))
	if event is InputEventMouseMotion:
		if dragging:
			move_pivot(-strength_move * event.relative)
			if _WindowViewData.visible:
				_WindowViewData.rect_position = get_local_mouse_position()

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_ContainerChart_resized()
	_on_ContainerXLabel_resized()
	_on_ContainerYLabel_resized()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	process()

func view_point(_point : SuperChartDataPoint):
	if viewing_point != _point:
		viewing_point = _point
		_WindowViewData.popup(Rect2(
			get_local_mouse_position(),
			_WindowViewData.rect_size
		))
		_WindowViewData.activate(
			line_title[_point.super_chart_data_line.line_index],
			_point.point_modulate,
			_point.header,
			str(_point.value)
		)
	pass

func move_pivot(vec : Vector2):
	pivot += zoom * vec

func change_zoom(_zoom : float):
	zoom = _zoom

func read_data(
	_headers := [],
	_data := [],
	_line_title := []
):
	headers = _headers
	data = _data
	line_title = _line_title
	pass

func read_file(file_path : String):
	var file := File.new()
	var _err : int = file.open(file_path, File.READ)
	if _err != 0:
		printerr("Open File Error!(%d)" % _err)
	var content : String = file.get_as_text()
	file.close()
	_read_string(content)
	pass

func _read_string(_data_string : String):
	data_string = _data_string
	var _rows := []
	if row_delimiter == "\\n":
		_rows = data_string.split("\n")
	assert(_rows.size() > 1)
	for i in _rows.size():
		var row : String = _rows[i]
		if row.length() == 0 || row.find(element_delimiter) == -1:
			continue
		if i == 0:
			var _temp : Array = row.split(element_delimiter)
			headers = _temp.slice(0, _temp.size() - 2)
			data.clear()
			line_title.clear()
		else:
			var _temp : Array = row.split(element_delimiter)
			var _temp2 := []
			for j in headers.size():
				_temp2.append(float(_temp[j]))
			if _temp.size() >= headers.size():
				line_title.append(_temp[headers.size()])
			else:
				line_title.append("")
			data.append(_temp2)
	pass

func _find_top_and_bottom():
	value_top = data[0][0]
	value_bottom = data[0][0]
	for i in data.size():
		for j in data[i].size():
			if data[i][j] <= value_bottom:
				value_bottom = data[i][j]
				index_point_bottom = Vector2(i, j)
			if data[i][j] >= value_top:
				value_top = data[i][j]
				index_point_top = Vector2(i, j)

func init_all():
	init_chart()
	init_data_lines()
	init_grid()
	init_xylabel()

func init_grid():
	_SuperChartGrid.init_grid(
		self, 
		grid_vertical_count,
		grid_line_width,
		grid_color
	)
	pass

func init_data_lines():
	for i in _DataLines.get_children():
		i.queue_free()
	for i in _ListLineTitle.get_children():
		i.queue_free()
	assert(data.size() > 0)
	assert(pool_line_color.size() > 0)
	assert(pool_point_color.size() > 0)
	assert(pool_point_type.size() > 0)
	_find_top_and_bottom()
	var _index_pool_line_color := 0
	var _index_pool_point_color := 0
	var _index_pool_point_type := 0
	for i in data.size():
		var new_data_line : SuperChartDataLine = scene_data_line.instance()
		_DataLines.add_child(new_data_line)
		var _point_type_string : String = pool_point_type[_index_pool_point_type]
		var _point_type_int : int = -1
		match _point_type_string:
			"circle":
				_point_type_int = SuperChartDataPoint.POINT_TYPE.CIRCLE
			"rect":
				_point_type_int = SuperChartDataPoint.POINT_TYPE.RECT
			"triangle":
				_point_type_int = SuperChartDataPoint.POINT_TYPE.TRIANGLE
		var new_line_title = scene_line_title.instance()
		_ListLineTitle.add_child(new_line_title)
		new_line_title.set_point_type(_point_type_int)
		new_line_title.set_font(font_line_title_info)
		new_line_title.set_title(line_title[i])
		new_line_title.set_color(pool_point_color[_index_pool_point_color])
		new_data_line.init_data_line(
			self,
			i,
			data[i],
			line_width,
			pool_line_color[_index_pool_line_color],
			pool_point_color[_index_pool_point_color],
			_point_type_int,
			point_size
		)
		_index_pool_line_color += 1
		_index_pool_point_color += 1
		_index_pool_point_type += 1
		if _index_pool_line_color >= pool_line_color.size():
			_index_pool_line_color = 0
		if _index_pool_point_color >= pool_point_color.size():
			_index_pool_point_color = 0
		if _index_pool_point_type >= pool_point_type.size():
			_index_pool_point_type = 0
	pass

func init_chart():
	_Viewport.size = viewport_size
	_on_ContainerChart_resized()
	pass

func init_xylabel():
	print(font_x_label)
	_SuperChartXLabel.init_x_label(
		self,
		font_x_label,
		color_x_label
	)
	_SuperChartYLabel.init_y_label(
		self,
		font_y_label,
		color_y_label,
		pad_decimals_y_label
	)


func set_viewport_size(_viewport_size):
	viewport_size = _viewport_size
	_Viewport.size = viewport_size

func get_texture() -> ViewportTexture:
	return _Viewport.get_texture()

func process():
	mouse_pos_in_chart = get_local_mouse_position() - _ContainerChart.rect_position
	mouse_pos_in_chart *= zoom
	var size : Vector2 = viewport_size * zoom
	_Viewport.size = size
	chart_view_rect = Rect2(pivot - size / 2, size)
	for i in _DataLines.get_children():
		i.process()
	_SuperChartGrid.process()
	var index_dic_h : Dictionary = _SuperChartGrid.index_dic_h
	var view_range_v : Vector2 = _SuperChartGrid.view_range_v
	_SuperChartXLabel.view_size = _ContainerXLabel.rect_size
	_SuperChartYLabel.view_size = _ContainerYLabel.rect_size
	_SuperChartXLabel.index_dic_h = index_dic_h
	_SuperChartXLabel.process()
	_SuperChartYLabel.view_range_v = view_range_v
	_SuperChartYLabel.process()

func focus_point(_point : SuperChartDataPoint):
	focusing_point = _point

func unfocus_point(_point : SuperChartDataPoint):
	if focusing_point == _point:
		focusing_point = null

func _on_ContainerChart_resized():
	set_viewport_size(_ContainerChart.rect_size)
	pass # Replace with function body.


func _on_ContainerXLabel_resized():
	_ViewportXLabel.size = _ContainerXLabel.rect_size
	pass # Replace with function body.



func _on_ContainerYLabel_resized():
	_ViewportYLabel.size = _ContainerYLabel.rect_size
	pass # Replace with function body.


func _on_WindowViewData_popup_hide():
	viewing_point = null
	pass # Replace with function body.
