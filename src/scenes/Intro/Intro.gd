extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	OS.window_maximized = true
	
	$Label.self_modulate.a = 0
	$Label2.self_modulate.a = 0
	$EndScreen.self_modulate.a = 0
	

func _input(event):
	
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE and event.pressed:
			next()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func next():
	get_tree().change_scene("res://src/scenes/World/World.tscn")
