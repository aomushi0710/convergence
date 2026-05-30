extends Node2D

@export var stage_length: int = 2000 ## ステージの長さ
@export var interval: int = 10 ## 目盛り間隔
@export var line_color: Color = Color.WHITE

func _draw() -> void:
	var font: Font = ThemeDB.fallback_font
	var font_size: int = 30
	
	# 0mからステージの終点まで、指定した間隔（interval_m）でループする
	for i in range(0, stage_length + 1, interval):
		var x_pos: float = i * 100.0
		
		# 縦線を引く (Vector2(X, Y) の指定。Yのマイナスは上方向)
		# 地面から上に40pxの線を引く
		draw_line(Vector2(x_pos, 0), Vector2(x_pos, -40), line_color, 2.0)
		
		var text: String = str(i) + "m"
		
		draw_string(font, Vector2(x_pos + 5, -15), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, line_color)
