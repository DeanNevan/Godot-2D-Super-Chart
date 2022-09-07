extends Control

func _ready():
	$SuperChart.read_file("res://addons/DrunkBull.SuperChart/assets/sampledata/test.csv")
#	$SuperChart.read_data(
#		["header1", "header2", "header3", "header4"],
#		[
#			[10, 20, 30, 40],
#			[5.5, 15.5, 10.5, 12.2],
#			[-5, -4, -3, -0]
#		],
#		["line1", "line2", "line3"]
#	)
#	$SuperChart.read_data(
#		["header1", "header2"],
#		[
#			[10, 20]
#		],
#		["line1"]
#	)
	$SuperChart.init_all()

func _process(_delta):
	$LabelFPS.text = str(Performance.get_monitor(Performance.TIME_FPS))
	pass
