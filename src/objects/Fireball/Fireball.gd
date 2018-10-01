extends Area2D

var dir = Vector2()
var speed = 100

var target = Vector2()

func _ready():
	
	monitoring = false
	
	$Sprite/Particle.show()
	
	$AnimationPlayer.play("flying")
	
	pass#dir = Vector2(cos(rotation), sin(rotation))
	

func _physics_process(delta):
	
	if target != null:
		#dir = Vector2(cos(rotation), sin(rotation))
	
		position += (dir * speed) *delta
		
		$Sprite.position.y = -position.distance_to(target) / 5
	
		if position.distance_to(target) < 10:
			explode()

func explode():
	monitoring = true
	$Sprite/Particle.emitting = false
	$AnimationPlayer.play("explode")
	$Explosion.play()
	$Ground.texture = get_parent()._ground_1 if randi() % 100 > 50 else get_parent()._ground_2
	$Shadow.hide()
	$Ground.show()
	target = null
	$DeathTimer.start()


func _on_Fireball_body_entered(body):
	if body.collision_layer != 1:
		body.hurt(1)


func _on_DeathTimer_timeout():
	queue_free()


	
