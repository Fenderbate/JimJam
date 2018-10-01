extends Node2D

var _scale = preload("res://src/objects/Scale/Scale.tscn")
var _fireball = preload("res://src/objects/Fireball/Fireball.tscn")

var _ground_1 = preload("res://src/objects/Fireball/ground_sprite_1.png")
var _ground_2 = preload("res://src/objects/Fireball/ground_sprite_2.png")

var player = null

var dir = Vector2()
var angle = 0

var speed_mult = 0.2

var attacks = []
var attack_index = -1

var current_attack_index = 0

var end = false

var start = true

var realstart = false

var head_pos = 0 # 0 - top, 1 - left, 2 - bot, 3 - right

func _ready():
	
	var ret_curve = Curve2D.new()
	
	for point in $CurvePoints.get_children():
		ret_curve.add_point(point.global_position)
	
	$ArenaEdge.curve = ret_curve
	$ArenaInnerEdge.curve = ret_curve
	
	
	
	randomize()
	
	player = get_parent().get_node("Player")
	
	player.connect("dead",self,"_on_player_death")
	
	$AnimationPlayer.play("start")
	
	

func _physics_process(delta):
	
	$ArenaEdge/Head.unit_offset += delta * speed_mult
	
	#$ArenaInnerEdge/ScaleShooter.unit_offset += delta * speed_mult * 1.5
	
	var dir = ($ArenaEdge/Head.global_position - global_position).normalized()
	angle = 180 + rad2deg(atan2(dir.x,dir.y))
	
	#print(angle)
	
	if angle < 90 and angle > 45 and head_pos == 0:
		head_pos = 1
		
		$ArenaEdge/Head/UpDown.hide()
		$ArenaEdge/Head/Side.scale.x = 4
		$ArenaEdge/Head/Side.show()
	
	elif angle > 135 and head_pos == 1:
		
		$ArenaEdge/Head/Side.hide()
		$ArenaEdge/Head/UpDown.frame = 1
		$ArenaEdge/Head/UpDown.show()
		
		head_pos = 2
		
	
	elif angle > 225 and head_pos == 2:
		head_pos = 3
		
		$ArenaEdge/Head/UpDown.hide()
		$ArenaEdge/Head/Side.scale.x = -4
		$ArenaEdge/Head/Side.show()
		
	
	elif angle > 315 and head_pos == 3:
		
		head_pos = 0
		
		$ArenaEdge/Head/UpDown.show()
		$ArenaEdge/Head/UpDown.frame = 0
		$ArenaEdge/Head/Side.hide()
		
		
		
	
	pass
	

func end():
	
	yield(wait_for_seconds(6.0), "completed")
	
	$AnimationPlayer.play("end")
	player.get_node("CanvasLayer/Container/Health").hide()
	

func _on_player_death():
	
	$Canvas/OverseerText.text = "This one died too. What a shame. The next one shall do better."
	$Timers/DeathTimer.start()
	
	pass

func generate_attacks(length = 20):
	
	randomize()
	
	for i in range(length):
		var r = randi() % 3
		
		match r:
			0:
				attacks.append({r:floor(rand_range(10,21))})
			1:
				attacks.append({r:floor(rand_range(15,31))})
			2:
				attacks.append({r:rand_range(0.25,0.75)})
	
	attack_index = -1
	current_attack_index = 0
	
	print("Number of generated attacks: ",attacks.size())
	
	pick_next_attack()
	
	
	

func pick_next_attack():
	
	if end == true or player.dead:
		return
	
	if current_attack_index > 0:
		match attacks[attack_index].keys()[0]:
			0:
				fireball()
				current_attack_index -= 1
			1:
				scales()
				current_attack_index -= 1
			2:
				tails(randi() % 8, attacks[attack_index].values()[0])
				current_attack_index -= 1
		return
	
	else:
			
		
		attack_index += 1
		
		print("ROUND ",attack_index)
		
		if attack_index == attacks.size():
			print("The trial has ended, release the candidate!", attack_index," - ",attacks.size())
			$Canvas/OverseerText.text = "The trial has ended, release the candidate!"
			end = true
			end()
			return
		elif attack_index == attacks.size() / 2:
			$Canvas/OverseerText.text = "You're halfway through, stand your ground!"
			yield(wait_for_seconds(3.0), "completed")
		else:
			yield(wait_for_seconds(1.0), "completed")
		
		if attack_index >= attacks.size():
			print("Attack index overindexing the array. ", attack_index," - ",attacks.size())
			return
		
		$Canvas/OverseerText.text = ""
		
		match attacks[attack_index].keys()[0]:
			0:
				fireball()
				current_attack_index = attacks[attack_index].values()[0]
			1:
				scales()
				current_attack_index = attacks[attack_index].values()[0]
			2:
				randomize()
				tails(randi() % 8, attacks[attack_index].values()[0])
				current_attack_index = randi() % 3
		
		pass
			
	

func fireball():
	
	$Timers/FireballTimer.start()
	

func scales():
	
	$Timers/ScaleTimer.start()
	

func tails(which, speed = 0.5):
	
	get_parent().get_node("Sweeper").playback_speed = speed
	
	match which:
		0:
			get_parent().get_node("Sweeper").play("top")
		1:
			get_parent().get_node("Sweeper").play("left")
		2:
			get_parent().get_node("Sweeper").play("bot")
		3:
			get_parent().get_node("Sweeper").play("right")
		4:
			get_parent().get_node("Sweeper").play("top_bot")
		5:
			get_parent().get_node("Sweeper").play("left_right")
		6:
			get_parent().get_node("Sweeper").play("all")
	
	if !$Sweep.playing:
		$Sweep.play()
	


func _on_ScaleTimer_timeout():
	
	$ArenaInnerEdge/ScaleShooter.unit_offset = rand_range(0, 2)
	$ArenaInnerEdge/ScaleShooter.look_at(player.position)
	
	var s = _scale.instance()
	s.position = $ArenaInnerEdge/ScaleShooter.global_position - ($ArenaInnerEdge/ScaleShooter.global_position - global_position).normalized() * Vector2(20, 20)
	
	s.speed = 600
	
	s.rotation = $ArenaInnerEdge/ScaleShooter.rotation
	
	add_child(s)
	
	pick_next_attack()
	
	pass
	


func _on_FireballTimer_timeout():
	
	var f = _fireball.instance()
	
	f.position = $ArenaEdge/Head.position
	
	f.speed = 300
	
	f.target = player.position
	
	f.dir = (player.position - $ArenaEdge/Head.position).normalized()
	
	add_child(f)
	
	
	#f.look_at(player.position)
	
	pick_next_attack()
	
	pass

func _on_spinning_finished():
	
	
	pass

func wait_for_seconds(seconds):
	var timer = 0.0
	
	while timer < seconds:
		timer += get_process_delta_time()
		yield(get_tree(), "idle_frame")


func _on_StartTimer_timeout():
	
	if start:
		$Canvas/OverseerText.text = "Ready yourself!"
		$Timers/StartTimer.wait_time = 2
		$Timers/StartTimer.start()
		start = false
		return
	
	
	if realstart == false:
		realstart = true
		$Hint.hide()
		generate_attacks(14)
		return
	


func _on_DeathTimer_timeout():
	
	$AnimationPlayer.play("death")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if player.dead:
		get_tree().change_scene("res://src/scenes/Intro/Intro.tscn")
		
	if start == true:
		
		$Canvas/OverseerText.text = "Here's the next candidate.\n Let us see what you are capable of!"
	
		$Timers/StartTimer.start()


func _on_WaitTimer_timeout():
	pass # replace with function body


func _on_Sweeper_animation_finished(anim_name):
	
	if $Sweep.playing:
		$Sweep.stop()
	
	pick_next_attack()
	
