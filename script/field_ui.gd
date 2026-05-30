class_name FieldUI
extends Control

@export var ui_rolling_shape: RollingShape
@export var stage_rolling_shape: RollingShape
@export var stage: Stage

@export var accept_dialog: AcceptDialogManager
@export var gold_label: RichTextLabel

@export var convergence_panel: ParameterPanel
@export var rocket_start_panel: ParameterPanel
@export var tornado_panel: ParameterPanel
@export var ice_ball_panel: ParameterPanel
@export var gold_rush_panel: ParameterPanel
@export var time_is_money_panel: ParameterPanel
@export var time_to_money_panel: ParameterPanel

@export var color_rect: ColorRect

var all_panel: Array[ParameterPanel] ## 全パネルの反復処理用配列

var time_to_gold_rate: int = 0

var gold_multiplier: float = 1.0:
	set(value):
		gold_multiplier = value
		ui_rolling_shape.polygon_2d.color = Color.from_hsv(0.142, 1, value / 10.0)
		stage_rolling_shape.polygon_2d.color = Color.from_hsv(0.142, 1, value / 10.0)

var gold: int:
	set(value):
		gold = maxi(0, value)
		gold_label.text = "[color=gold]%4d G[/color]" % value
		SaveManager.game_data["gold"] = gold
		SaveManager.save_game()
		_gold_update()


func _ready() -> void:
	color_rect.show()
	stage.best_distance = SaveManager.game_data["high_score"]
	gold = SaveManager.game_data["gold"]
	
	all_panel = [
		convergence_panel,
		rocket_start_panel,
		tornado_panel,
		ice_ball_panel,
		gold_rush_panel,
		time_is_money_panel,
		time_to_money_panel,
	]
	
	for i in all_panel.size():
		all_panel[i].level = SaveManager.game_data["level"][i]
		_update(all_panel[i])
	
	_gold_update()
	
	var tween := color_rect.create_tween()
	tween.tween_property(color_rect, "self_modulate:a", 0, 1)
	tween.tween_callback(func(): color_rect.hide())

## アニメーション再生
func _process(delta: float) -> void:
	if Engine.time_scale <= 0: # 0除算防止
		return
	
	## [member Engine.time_scale]に基づいて等倍に戻されたdelta値
	var unscaled_delta := delta / Engine.time_scale
	ui_rolling_shape.rotation += unscaled_delta * (tornado_panel.level * 0.05)
	if ui_rolling_shape.rotation >= 360:
		ui_rolling_shape.rotation = 0

## 現在のレベルに合わせてパラメータを更新します
func _update(panel: ParameterPanel) -> void:
	var value := panel.parameter.get_value(panel.level)
	match panel.parameter.type:
		Parameter.Type.CONVERGENCE:
			ui_rolling_shape.sides = int(value)
			stage_rolling_shape.sides = int(value)
		
		Parameter.Type.ROCKET_START:
			stage.shoot_power = int(value)
		
		Parameter.Type.TORNADO:
			stage.torque_power = int(value)
		
		Parameter.Type.ICE_BALL:
			ui_rolling_shape.friction = value
			stage_rolling_shape.friction = value
		
		Parameter.Type.GOLD_RUSH:
			gold_multiplier = value
		
		Parameter.Type.TIME_IS_MONEY:
			stage_rolling_shape.time_scale_multiplier = value
		
		Parameter.Type.TIME_TO_MONEY:
			time_to_gold_rate = int(value)

## 全ての[ParameterPanel]に対して[method ParameterPanel.gold_update]を呼び出します
func _gold_update() -> void:
	for panel in all_panel:
		panel.gold_update(gold)


func _on_rolling_shape_run_finished(distance: float, time: float) -> void:
	var final_distance := int(distance / 100.0)
	var gold_value := int(final_distance * gold_multiplier)
	var final_time := int(time)
	var time_to_gold := int(final_time * time_to_gold_rate * gold_multiplier)
	
	var result_text := (
		"[color=red]%d m[/color] に到達しました！\n" % final_distance + 
		"[color=gold]%d G[/color] を手に入れた" % gold_value
	)
	if time_to_gold_rate > 0:
		result_text += (
			"\n\n～ [color=gold]Time to Money[/color] ～" +
			"\n%d 秒 が経過しました！" % final_time + 
			"\n[color=gold]%d G[/color] を追加で手に入れた" % time_to_gold
		)
	
	accept_dialog.display_dialog(result_text)
	gold += gold_value + time_to_gold


func _on_parameter_panel_level_upped(panel: ParameterPanel, gold_value: int) -> void:
	panel.level += 1
	gold -= gold_value
	
	_update(panel)
	
	SaveManager.game_data["level"][panel.parameter.type] += 1
	SaveManager.save_game()
