extends Area2D
tool

var dir = Vector2()
var speed = 100

func _ready():
	
	dir = Vector2(cos(rotation), sin(rotation))
	
	$Shoot.play()
	

func _physics_process(delta):
	
	dir = Vector2(cos(rotation), sin(rotation))
	
	position += (dir * speed) *delta
	


func _on_Scale_body_entered(body):
	
	if body.collision_layer != 1:
		body.hurt(1)
	
	queue_free()
	
