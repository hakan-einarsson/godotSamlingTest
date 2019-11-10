extends Area2D

var damage = 10
var source = null
var cast_time = 5
#onready var swing_timer=$SwingTimer
var ms = 0
var player_facing = null
var rot = null

# Called when the node enters the scene tree for the first time.

func get_cast_time():
	return cast_time
	
	
func hit(start_pos,target,body):
	source = body
	get_player_state(target)
	get_start_position(start_pos)
	
	rotate(rot)
	#swing_timer.start()
	
func get_start_position(pos):
	if player_facing == "Right":
		self.global_position=pos + Vector2(24,0)
	if player_facing == "Left":
		self.global_position=pos + Vector2(-24,0)
	if player_facing == "Up":
		self.global_position=pos + Vector2(0,22)
	if player_facing == "Down":
		self.global_position=pos + Vector2(0,-22)
		


func _on_SwingTimer_timeout():
	ms+=1
	if ms == cast_time:
		queue_free()
		
func get_player_state(target_position):
	var angleToMouse = get_angle_to(target_position)
	if abs(angleToMouse) <= 1:
		rot = deg2rad(0)
		player_facing = "Right"
	elif abs(angleToMouse) >= 2:
		rot = deg2rad(180)
		player_facing = "Left"
	else:
		if angleToMouse > 0:
			rot = deg2rad(90)
			player_facing = "Up"
		else:
			rot = deg2rad(-90)
			player_facing= "Down"



func _on_Sword_body_entered(body):
	if body.get_name() != "TileMap":
		body.take_damage(damage,source)
