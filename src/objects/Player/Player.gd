extends KinematicBody2D

signal dead

var dir = Vector2()
var speed = 350
var motion = Vector2()

const MAX_HEALTH = 5
var health = MAX_HEALTH

var invincible = false

var dead = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	
	if dead:
		return
	
	dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
	$Sprite.scale.x = dir.x * 1.2 if dir.x != 0 and $Sprite.scale.x != dir.x * 1.2 else $Sprite.scale.x
	
	dir.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	if Input.is_action_pressed("jump") and !$AnimationPlayer.is_playing():
		collision_layer = 0
		$Hitbox.collision_layer = 0
		$Jump.play()
		$AnimationPlayer.play("jump")
	
	dir = dir.normalized()
	
	motion = dir * speed
	
	motion = move_and_slide(motion)


func hurt(dmg):
	
	health -= dmg
	
	if health >= 0 and dead == false:
		$Hurt.play()
		
		$CanvasLayer/Container/Health.value = health
		
		invincible = true
		collision_layer = 0
		$Hitbox.collision_layer = 0
		$InvincibleTimer.start()
	
	if health <= 0 and dead == false:
		
		$Sprite.hide()
		$Death.scale.x = $Sprite.scale.x
		$AnimationPlayer.play("death")
		
		collision_layer = 0
		$Hitbox.collision_layer = 0
		
		dead = true
		
		emit_signal("dead")
		
		print("Implement death.")
		return
	
	
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if invincible == false:
		collision_layer = 2
		$Hitbox.collision_layer = 2


func _on_InvincibleTimer_timeout():
	invincible = false
	collision_layer = 2
	$Hitbox.collision_layer = 2
