extends Node

const SAVE_PATH := "user://save_data.json"

var game_data := {
	"high_score": 0,
	"gold": 0,
	"level": [
		1, # 収束
		1, # ロケットスタート
		1, # トルネード
		1, # アイスボール
		1, # ゴールドラッシュ
		0, # Time is Money
		0, # Time to Money
	],
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


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		save_game()
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var parsed_data = JSON.parse_string(json_string)
		_migrate_old_data(parsed_data)
		
		if parsed_data is Dictionary:
			game_data.merge(parsed_data, true)

## 辞書で管理していたパラメータのセーブデータを配列に変換します
func _migrate_old_data(data: Dictionary) -> void:
	if data.has("level") and typeof(data["level"]) == TYPE_DICTIONARY:
		var old_dict: Dictionary = data["level"]
		var new_array: Array = []
		
		# 既にデータが存在していれば差し替えを行い、そうでなければ初期値を格納
		for i in game_data["level"].size():
			if old_dict.has(str(i)):
				new_array.append(old_dict[str(i)])
			elif i <= 4:
				new_array.append(1) 
			else: # index5以降のパラメータは初期値が1
				new_array.append(0)
		
		data["level"] = new_array
