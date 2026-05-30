@tool
class_name ParameterPanel
extends Panel

## レベルが上がった時に発行されます[br]
## このシグナルを利用することで、消費するゴールドの値を保持しつつ[br]
## [method ParameterPanel._level_update]を呼び出せます
signal level_upped(panel: ParameterPanel, gold_value: int)

@export var parameter_label: RichTextLabel
@export var description_label: RichTextLabel
@export var level_label: RichTextLabel
@export var value_label: RichTextLabel
@export var gold_label: RichTextLabel
@export var button: Button

@export var parameter: Parameter:
	set(value):
		parameter = value
		_update()

@export var level: int = 1:
	set(value):
		level = value
		_level_update()

var upgrade_cost: int:
	set(value):
		upgrade_cost = value
		gold_update(value)


func _ready() -> void:
	_update()

## 全UIの見た目を更新します
func _update() -> void:
	if not parameter or not parameter_label:
		return
	
	parameter_label.text = "[color=%s][b]%s[/b][/color]" % [parameter.color_name, parameter.name]
	description_label.text = "[i]%s[/i]" % parameter.description
	
	_level_update()

## レベルが変化した時、影響を受けるUIの見た目を更新します
func _level_update() -> void:
	if not parameter or not parameter_label:
		return
	
	var value := parameter.get_value(level) ## 現在レベルの値
	var next_value := parameter.get_value(level + 1) ## 次レベルの値
	## 整数型として表示されるべきかどうかを、小数点以下が0かで判別する
	var is_int: bool = value == int(value) and next_value == int(next_value)
	
	if level >= parameter.max_level:
		level_label.text = "Lv. [color=red]MAX[/color]"
		
		if is_int:
			value_label.text = "%4d" % value
		else:
			value_label.text = "%4.1f" % value
		
	else:
		level_label.text = "Lv.%4d    Lv.%4d" % [level, level + 1]
		
		if is_int:
			value_label.text = "%4d → [color=gray]%4d[/color]" % [value, next_value]
		else:
			value_label.text = "%4.1f → [color=gray]%4.1f[/color]" % [value, next_value]
		
		upgrade_cost = parameter.get_upgrade_cost(level + 1)

## 所持ゴールド量が変化した時、アップグレードボタンの状態を更新します
func gold_update(gold: int) -> void:
	if level >= parameter.max_level:
		button.disabled = true
		gold_label.text = "[color=red]MAX[/color]"
	elif upgrade_cost > gold:
		button.disabled = true
		gold_label.text = "[color=gray]%d G[/color]" % upgrade_cost
	else:
		button.disabled = false
		gold_label.text = "[color=gold]%d G[/color]" % upgrade_cost


func _on_button_button_up() -> void:
	level_upped.emit(self, upgrade_cost)
