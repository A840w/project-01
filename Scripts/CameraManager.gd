extends Node

var shake_amount := 0.0

func _ready() -> void:
	randomize()

func shake(amount := 2.0):
	shake_amount = max(shake_amount, amount)

func update_shake(delta: float) -> Vector2:
	if shake_amount <= 0.01:
		return Vector2.ZERO

	var offset := Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)
	)

	shake_amount = lerpf(shake_amount, 0.0, delta * 25.0)

	return offset
