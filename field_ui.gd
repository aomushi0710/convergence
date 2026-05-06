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

@export var color_rect: ColorRect

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
	stage.best_distance = SaveManager.game_data["high_score"]
	gold = SaveManager.game_data["gold"]
	
	var all_panel: Array[ParameterPanel] = [
		convergence_panel,
		rocket_start_panel,
		tornado_panel,
		ice_ball_panel,
		gold_rush_panel,
	]
	
	for i in all_panel.size():
		all_panel[i].level = SaveManager.game_data["level"][str(i)]
		_update(all_panel[i])
	
	_gold_update()
	
	var tween := color_rect.create_tween()
	tween.tween_property(color_rect, "self_modulate:a", 0, 1)
	tween.tween_callback(func(): color_rect.hide())

## アニメーション再生
func _process(delta: float) -> void:
	ui_rolling_shape.rotation += delta * (tornado_panel.level * 0.05)
	if ui_rolling_shape.rotation >= 360:
		ui_rolling_shape.rotation = 0

## 現在のレベルに合わせてパラメータを更新します
func _update(panel: ParameterPanel) -> void:
	match panel.parameter.type:
		Parameter.Type.CONVERGENCE:
			ui_rolling_shape.sides = panel.parameter.get_value(panel.level)
			stage_rolling_shape.sides = panel.parameter.get_value(panel.level)
		
		Parameter.Type.ROCKET_START:
			stage.shoot_power = panel.parameter.get_value(panel.level)
		
		Parameter.Type.TORNADO:
			stage.torque_power = panel.parameter.get_value(panel.level)
		
		Parameter.Type.ICE_BALL:
			ui_rolling_shape.friction = panel.parameter.get_value(panel.level)
			stage_rolling_shape.friction = panel.parameter.get_value(panel.level)
		
		Parameter.Type.GOLD_RUSH:
			gold_multiplier = panel.parameter.get_value(panel.level)

## 全ての[ParameterPanel]に対して[method ParameterPanel.gold_update]を呼び出します
func _gold_update() -> void:
	var all_panel: Array[ParameterPanel] = [
		convergence_panel,
		rocket_start_panel,
		tornado_panel,
		ice_ball_panel,
		gold_rush_panel,
	]
	
	for panel in all_panel:
		panel.gold_update(gold)


func _on_rolling_shape_run_finished(final_distance: float) -> void:
	var distance_value := int(final_distance / 100.0)
	var gold_value := int(distance_value * gold_multiplier)
	
	accept_dialog.display_dialog(
		"[color=red]%d m[/color] に到達しました！\n" % distance_value + 
		"[color=gold]%d G を手に入れた" % gold_value
	)
	gold += gold_value


func _on_parameter_panel_level_upped(panel: ParameterPanel, gold_value: int) -> void:
	panel.level += 1
	gold -= gold_value
	
	_update(panel)
	
	SaveManager.game_data["level"][str(panel.parameter.type)] += 1
	SaveManager.save_game()
