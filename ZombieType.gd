extends KinematicBody2D

var speed = 50
var path = PoolVector2Array() setget set_path
onready var nav_2d = $scene
onready var line = get_node("../Line2D")
onready var animator = $Sprite/AnimationPlayer
var target = null
var direction=Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("Walk")

func _physics_process(delta):
	if path.size() > 0:
		print(path.size(), path[0]==target.position)
	if direction == Vector2():
		animator.stop()
	else:
		animator.play("Walk")
	if target:
		set_path(get_tree().get_root().get_node("scene").return_path(target.position,position))
		#set_path(get_tree().get_root().get_node("scene").return_path(global_position,get_node("../protagonist").position)) #så hur gör jag för aggro här?
		line.points=path
		var move_distance = speed
		move_along_path(move_distance)

func _input(event):
	pass

func move_along_path(distance):
	var start_point = position
	#print(path.size())
	for i in range(path.size()): #alla steg i path
		var distance_to_next = start_point.distance_to(path[0]) #räknar ut hur långt det är till nästa steg
		#print(distance_to_next)
		if distance*0.0166667 <= distance_to_next and distance >= 0.0:
			direction = Vector2(cos(get_angle_to(path[0])),sin(get_angle_to(path[0])))
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

func _on_Area2D_body_entered(body):
	if body.name != "TileMap":
		target = body
