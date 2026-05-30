extends CanvasLayer

@export var distance_label: RichTextLabel
@export var best_distance_label: RichTextLabel
@export var timer_label: RichTextLabel
@export var fast_forward_label: RichTextLabel

var tween: Tween

func _on_rolling_shape_run_updated(distance: float, time: float) -> void:
	distance_label.text = "到達距離: %3d m" % (distance / 100.0)
	timer_label.text = "%05.2f" % time


func _on_stage_best_distance_changed(distance: int) -> void:
	best_distance_label.text = "最高記録: %3d m" % distance


func _on_rolling_shape_run_finished(_distance: float, _time: float) -> void:
	if tween:
		tween.kill()
	
	fast_forward_label.hide()
	_on_rolling_shape_run_updated(0, 0)


func _on_rolling_shape_fast_forward_started() -> void:
	if Engine.time_scale <= 1.0:
		return
		
	fast_forward_label.show()
	## 早送りマークアニメーション
	tween = fast_forward_label.create_tween().set_loops()
	tween.tween_callback(func(): fast_forward_label.text = "[color=orange]▶[/color]▶ x%3.1f" % Engine.time_scale)
	tween.tween_interval(0.4)
	tween.tween_callback(func(): fast_forward_label.text = "[color=orange]▶▶[/color] x%3.1f" % Engine.time_scale)
	tween.tween_interval(0.8)
	tween.tween_callback(func(): fast_forward_label.text = "▶[color=orange]▶[/color] x%3.1f" % Engine.time_scale)
	tween.tween_interval(0.4)
	tween.tween_callback(func(): fast_forward_label.text = "▶▶ x%3.1f" % Engine.time_scale)
	tween.tween_interval(0.4)
