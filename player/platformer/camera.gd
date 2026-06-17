extends Camera2D


@export var player_group := "aim"
@export var follow_speed := 0.08

func _process(_delta):
	offset = CameraManager.update_shake(_delta)

	var player = get_tree().get_first_node_in_group(player_group)

	if player == null:
		return

	global_position = global_position.lerp(
		player.global_position,
		follow_speed
	)
