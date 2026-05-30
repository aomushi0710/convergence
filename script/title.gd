extends Node2D

@export var camera_2d: Camera2D
@export var version_label: RichTextLabel

var is_transitioning: bool


func _ready() -> void:
	version_label.text = "ver.%s" % ProjectSettings.get_setting("application/config/version")


func _unhandled_input(event: InputEvent) -> void:
	var is_key_pressed = event is InputEventKey and not event.is_echo()
	var is_tapped = event is InputEventMouseButton or event is InputEventScreenTouch
	if event.is_pressed() and (is_key_pressed or is_tapped):
		var tween = camera_2d.create_tween().set_parallel()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property(camera_2d, "zoom", Vector2(7, 7), 2)
		tween.tween_property(camera_2d, "position:y", 650, 2)
		tween.chain().tween_callback(func(): 
			get_tree().change_scene_to_file("res://scene/field.tscn"))
