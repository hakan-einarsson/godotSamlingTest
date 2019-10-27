extends KinematicBody2D

var speed = 100
var direction = Vector2()
var movement = Vector2()

# Called when the node enters the scene tree for the first time.

func _input(event):
	movement.x = (int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left")))*speed
	movement.y = (int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up")))*speed

	if event.is_action_pressed("ui_accept"): 
		print("shoot")
		# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(movement)
