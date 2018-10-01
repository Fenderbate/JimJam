extends Area2D

signal spinning_finished

var spinning = false

var spin_speed = 5

var rot_origin

var rotated = 0

func _ready():
	
	rot_origin = rotation
	

func _physics_process(delta):
	
	if spinning:
		rotation_degrees += spin_speed
		rotated += spin_speed
		if rotated >= 360:
			spinning = false
			rotation = rot_origin
			rotated = 0
			emit_signal("spinning_finished")
	

func _on_Tail_body_entered(body):
	
	if body.collision_layer != 1:
		body.hurt(1)
	
