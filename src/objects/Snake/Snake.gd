extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	
	position = get_global_mouse_position()
	
	var i = 0
	
	for p in $Pieces.get_children():
		
		if i == 0:
			pass
		
		
		pass
	


