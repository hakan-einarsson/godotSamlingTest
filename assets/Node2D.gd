extends KinematicBody2D

var speed = 100.0
var path = PoolVector2Array() setget set_path

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var move_distance = speed
	move_along_path(move_distance)
	
func _input(event):
	pass

func move_along_path(distance):
	var start_point = position
	print(path.size())
	for i in range(path.size()): #alla steg i path
		var distance_to_next = start_point.distance_to(path[0]) #räknar ut hur långt det är till nästa steg
		print(distance_to_next)
		if distance*0.0166667 <= distance_to_next and distance >= 0.0:
			var direction = Vector2(cos(get_angle_to(path[0])),sin(get_angle_to(path[0])))
			move_and_slide(direction * distance,Vector2(0,0),false,4,1)
			#move_and_slide(start_point.linear_interpolate(path[0], distance/distance_to_next),Vector2(0,0))
			break
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func set_path(value):
	path = value
	if value.size() == 0:
		return
	set_process(true)