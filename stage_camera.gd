extends Camera2D

@export var target: RollingShape

func _physics_process(delta: float) -> void:
	if target:
		global_position.x = maxi(1920 / 2, target.global_position.x)
