extends Node2D

@export var camera_2d: Camera2D

var is_transitioning: bool

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.is_pressed() and not is_transitioning:
			var tween = camera_2d.create_tween().set_parallel()
			tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
			tween.tween_property(camera_2d, "zoom", Vector2(7, 7), 2)
			tween.tween_property(camera_2d, "position:y", 650, 2)
			tween.chain().tween_callback(func(): 
				get_tree().change_scene_to_file("res://field.tscn"))
