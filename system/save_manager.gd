extends Node

const SAVE_PATH := "user://save_data.json"

var game_data := {
	"high_score": 0,
	"gold": 0,
	"level": {
		0: 1,
		1: 1,
		2: 1,
		3: 1,
		4: 1,
	},
}

func _ready() -> void:
	load_game()

func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(game_data)
		file.store_string(json_string)
		file.close()
	else:
		push_error("セーブデータの保存に失敗しました。")

# ロード（ファイルからJSONを読み込んで辞書に戻す）
func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		save_game()
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var parsed_data = JSON.parse_string(json_string)
		
		if parsed_data is Dictionary:
			game_data.merge(parsed_data, true)
