extends KinematicBody2D

var speed = 50
var path = PoolVector2Array() 
onready var nav_2d = $scene
onready var line = get_node("../Line2D")
onready var animator = $Sprite/AnimationPlayer
var target = null
var direction=Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("Walk")

func _physics_process(delta):
	if direction == Vector2():
		animator.stop()
	else:
		animator.play("Walk")
	if target:
		path = get_tree().get_root().get_node("scene").return_path(target.position,position)
		line.points=path
		var move_distance = speed
		move_along_path(move_distance)

func _input(event):
	pass

func move_along_path(distance):
	var start_point = position
	var distance_to_next = start_point.distance_to(path[1])
	direction = Vector2(cos(get_angle_to(path[1])),sin(get_angle_to(path[1])))
	print(direction)
	move_and_slide(direction * speed,Vector2(0,0),false,4,1)

	
func set_path(value):
	path = value
	if value.size() == 0:
		return
	set_process(true)

func _on_Area2D_body_entered(body):
	if body.name != "TileMap":
		target = body
