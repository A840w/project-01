extends Area2D

@export var atk_dmg := 2

var kn_strength := 250.0
var kn_time := 0.1

func _ready() -> void:
	connect("body_entered", attack)
	
func attack(body):
	if body.has_method("take_damage"):
		body.take_damage(atk_dmg)
		var kn_dir = (body.global_position - global_position).normalized()
		body.apply_knockback(kn_dir, kn_strength, kn_time)
		CameraManager.shake(2.5)
		
