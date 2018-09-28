extends KinematicBody2D

var dir = Vector2()
var speed = 350
var motion = Vector2()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	
	dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
	dir.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	dir = dir.normalized()
	
	motion = dir * speed
	
	motion = move_and_slide(motion)
