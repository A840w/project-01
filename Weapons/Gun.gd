extends Node2D

const bullet_scene = preload("res://Weapons/bullet/bullet_1.tscn")

@onready var timer := $ShootTimer
@onready var muzzle := $Muzzle

var fire_rate := 0.25
var can_shoot := true

func _ready() -> void:
	timer.connect("timeout", timer_timeout)
	timer.wait_time = fire_rate

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()
		can_shoot = false
		timer.start()
		


func shoot():
	var new_bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(new_bullet)
	new_bullet.global_position = muzzle.global_position
	new_bullet.global_rotation = muzzle.global_rotation
	
	
func timer_timeout():
	can_shoot = true
