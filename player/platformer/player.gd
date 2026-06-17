extends CharacterBody2D

@onready var Body := $Body
@onready var anim := $AnimationPlayer
@onready var aim_marker := $aim

@export var marker_radius := 15.0
@export var marker_smooth := 5.0
@export var state : STATES

var health := 5
var max_health := health
var atk_dmg := 1

const SPEED := 230.0
const JUMP_VELOCITY := -350.0
const ACCEL := 15

const COYOTE_TIME := 0.1
const JUMP_BUFFER_TIME := 0.1

var coyote_timer := 0.0
var jump_buffer := 0.0

var facing_right = true
var jumped := false

enum STATES { IDLE, RUN, JUMP, FALL}

var target_scale := Vector2.ONE
var current_scale := Vector2.ONE

var current_marker_pos := Vector2.ZERO

var knockback: Vector2 = Vector2.ZERO
var knockback_timer := 0.0


func _ready() -> void:
	aim_marker.add_to_group("aim")

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		# GRAVITY
		velocity += get_gravity() * delta
		
	
	# squish and stretch
		
	if not is_on_floor():
		if velocity.y > 10:
			current_marker_pos = Vector2.DOWN * marker_radius
			
		if velocity.y < 0:
			target_scale = Vector2(0.85, 1.15) # up → stretch
		else:
			target_scale = Vector2(1.15, 0.85) # down → squish
	else:
		target_scale = Vector2.ONE
		
	# Coyote Time
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	# Jump Buffer
	if Input.is_action_just_pressed("Jump"):
		jump_buffer = JUMP_BUFFER_TIME
		jumped = true
	else:
		jump_buffer -= delta

	# Buffered + Coyote Jump
	if jump_buffer > 0.0 and coyote_timer > 0.0:
		jump()
		jump_buffer = 0.0
		coyote_timer = 0.0

	# Horizontal Movement
	var direction := Input.get_axis("Left", "Right")

	if direction != 0:
		velocity.x += direction * ACCEL
		velocity.x = clamp(velocity.x, -SPEED, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL)
	
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		pass
	
	
	handle_facing() 
	move_and_slide()
	squish_and_stretch()
	update_marker()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("H"):
		CameraManager.shake(2.0)

	
func jump():
	velocity.y = JUMP_VELOCITY
	$"Jump Particle".emitting = true
	

#         FACING

func handle_facing():
	if velocity.x < -10:
		facing_right = false
	elif velocity.x > 10:
		facing_right = true
	Body.scale.x = 1 if facing_right else -1



func state_machine():
	match state:
		STATES.IDLE:
			pass
		STATES.RUN:
			pass
		STATES.JUMP:
			pass
		STATES.FALL:
			pass



func update_marker():
	var dir := Vector2.ZERO

	# input direction (only left/right for platformer feel)
	dir.x = Input.get_axis("Left", "Right")

	# if player is in air, force vertical behavior
	if not is_on_floor():
		if velocity.y > 0:
			dir.y = 1   # falling → down
		elif velocity.y < 0:
			dir.y = -1  # jumping → up

	# fallback direction
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT if facing_right else Vector2.LEFT

	dir = dir.normalized()

	var target_pos := dir * marker_radius

	current_marker_pos = current_marker_pos.lerp(
		target_pos,
		marker_smooth * get_process_delta_time())

	aim_marker.position = current_marker_pos
	
	
	
func squish_and_stretch():
	current_scale = current_scale.lerp(target_scale, 0.2)
	Body.scale = Vector2(current_scale.x * (1 if facing_right else -1), current_scale.y)

func heal():
	health = max_health

func take_damage(dmg: int):
	anim.play("hit")
	health -= dmg
	print(health)

func update_health():
	pass

func apply_knockback(direction: Vector2, force: float, knockback_duration: float):
	knockback = direction * force
	knockback_timer = knockback_duration
	

	
	
