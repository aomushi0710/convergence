@tool
extends RigidBody2D
class_name RollingShape

signal distance_updated(distance: float)
signal run_finished(final_distance: float)

@export var line_2d: Line2D
@export var polygon_2d: Polygon2D
@export var collision_polygon_2d: CollisionPolygon2D

@export var sides: int = 4: ## 頂点数
	set(value):
		if polygon_2d and collision_polygon_2d:
			sides = value
			update_shape()

@export var friction: float = 1.0: ## 摩擦力
	set(value):
		if line_2d:
			friction = value
			physics_material_override.friction = value
			line_2d.self_modulate.r = value

var radius: int = 50 ## 半径

var is_stopped: bool = true
var active_time: float = 0.0 ## 発射されてからの経過秒数  

## 生成された[PackedVector2Array]をポリゴンに適用します
func update_shape() -> void:
	var points: PackedVector2Array = generate_polygon(sides, radius)
	polygon_2d.polygon = points
	collision_polygon_2d.polygon = points
	line_2d.points = points
	
	## [param RollingShape.sides]が増えるたびに、空気抵抗も低下させる
	var drag: float = lerp(1.0, 0.1, float(sides - 4) / 28.0)
	linear_damp = drag
	angular_damp = drag

## 正多角形の頂点を計算します
func generate_polygon(sides: int, r: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	## 奇数の多角形でも、下の辺を水平にするためのオフセット[br]PI/2(90°)で下を向かせる
	var base_offset: float = (PI / 2.0) - (PI / sides)
	
	for i in range(sides):
		## 2PIを頂点の数で割ってを算出し、オフセットを足した各頂点の角度
		var angle: float = (PI * 2.0 / sides) * i + base_offset
		
		var point := Vector2(cos(angle), sin(angle)) * r
		points.append(point)
		
	return points


func _physics_process(delta: float) -> void:
	if not is_stopped:
		distance_updated.emit(global_position.x)
		active_time += delta
		
		# 停止判定
		if active_time > 0.5 and linear_velocity.length() < 2.0 and abs(angular_velocity) < 0.1:
			is_stopped = true
			run_finished.emit(global_position.x)
			active_time = 0

## 自身を発射します
func launch(impulse: Vector2, torque: float) -> void:
	if not is_stopped:
		return
	
	is_stopped = false
	
	apply_impulse(impulse)
	apply_torque_impulse(torque)

## 発射前の初期状態に戻します
func _on_run_finished(final_distance: float) -> void:
	global_rotation = 0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	global_position.x = 0
