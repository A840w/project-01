extends Node

var shake_amount := 0.0
var time := 0.0

func shake(amount := 2.0):
	shake_amount = max(shake_amount, amount)

func update_shake(delta: float) -> Vector2:
	time += delta

	if shake_amount <= 0.01:
		return Vector2.ZERO

	# Smooth pseudo-noise (stable, not flickery)
	var noise_x = sin(time * 60.0) + sin(time * 120.0)
	var noise_y = cos(time * 55.0) + cos(time * 110.0)

	var offset := Vector2(noise_x, noise_y) * shake_amount * 0.5

	# Smoother decay (feels like damping instead of linear fade)
	shake_amount = move_toward(shake_amount, 0.0, delta * 6.0)

	return offset
