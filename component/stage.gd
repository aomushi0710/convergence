class_name Stage
extends Node2D

signal best_distance_changed(distance: int)

@export var stage_ui: CanvasLayer
@export var rolling_shape: RollingShape

var best_distance: int: ## 最高記録
	set(value):
		best_distance = maxi(best_distance, value)
		best_distance_changed.emit(value)

var shoot_power: int = 1000
var torque_power: int = 500

func _unhandled_input(event: InputEvent) -> void:
	var is_key_pressed = event is InputEventKey and not event.is_echo()
	var is_tapped = event is InputEventMouseButton or event is InputEventScreenTouch
	if event.is_pressed() and (is_key_pressed or is_tapped):
		shoot()

func shoot() -> void:
	var torque: float = torque_power * 10
	var impulse: Vector2 = (shoot_power + torque_power) * Vector2.RIGHT
	
	rolling_shape.launch(impulse, torque)

func reset() -> void:
	rolling_shape.global_rotation = 0
	rolling_shape.global_position.x = 0

func _on_rolling_shape_run_finished(final_distance: float) -> void:
	final_distance = int(final_distance / 100.0)
	if final_distance > best_distance:
		best_distance = final_distance
		SaveManager.game_data["best_score"] = best_distance
		SaveManager.save_game()
	
