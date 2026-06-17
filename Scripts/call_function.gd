extends Area2D


@export var body_type : BODY_TYPE
@export var set_type : TYPE
@export var node : Node
@export var function : String
@export var value : float
@export var delay : float


enum BODY_TYPE { ANY, PLAYER, PLATFORM}

enum TYPE { 
	CALL_FUNCTION, SET_VAR,
	TURN_OFF_AREA}

func _ready() -> void:
	connect("body_entered", body_entered)
	

func body_entered(body):
	await get_tree().create_timer(delay).timeout

	if !is_instance_valid(body):
		return

	match body_type:
		BODY_TYPE.ANY:
			match set_type:
				TYPE.CALL_FUNCTION:
					CallManager.call_node(node, function, [value])

				TYPE.SET_VAR:
					CallManager.set_var(node, function, value)

				TYPE.TURN_OFF_AREA:
					CallManager.set_var(node, "monitoring", false)

		BODY_TYPE.PLAYER:
			if body.is_in_group("player"):
				match set_type:
					TYPE.CALL_FUNCTION:
						CallManager.call_node(node, function, [value])

					TYPE.SET_VAR:
						CallManager.set_var(node, function, value)

					TYPE.TURN_OFF_AREA:
						CallManager.set_var(node, "monitoring", false)
		
		BODY_TYPE.PLATFORM:
			if body.is_in_group("m_platform"):
				match set_type:
					TYPE.CALL_FUNCTION:
						CallManager.call_node(node, function, [value])

					TYPE.SET_VAR:
						CallManager.set_var(node, function, value)

					TYPE.TURN_OFF_AREA:
						CallManager.set_var(node, "monitoring", false)
