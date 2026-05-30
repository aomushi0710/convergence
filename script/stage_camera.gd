extends Camera2D

@export var target: RollingShape

func _physics_process(_delta: float) -> void:
	if target:
		global_position.x = maxf(960, target.global_position.x)
