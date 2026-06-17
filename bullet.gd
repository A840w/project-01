extends RigidBody2D

var speed := 400.0

@onready var ray := $Ray


func _physics_process(delta: float) -> void:
	linear_velocity = Vector2.RIGHT.rotated(global_rotation) * speed
	if ray.is_colliding():
		set_physics_process(false )
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		hide()
