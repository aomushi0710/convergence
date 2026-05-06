extends CanvasLayer

@export var distance_label: RichTextLabel
@export var best_distance_label: RichTextLabel

func _on_rolling_shape_distance_updated(distance: float) -> void:
	distance_label.text = "到達距離: %3d m" % (distance / 100.0)


func _on_stage_best_distance_changed(distance: int) -> void:
	best_distance_label.text = "最高記録: %3d m" % distance


func _on_rolling_shape_run_finished(final_distance: float) -> void:
	distance_label.text = "到達距離: %3d m" % 0
