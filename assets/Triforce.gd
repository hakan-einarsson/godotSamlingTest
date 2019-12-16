extends Node2D

onready var timer = $Timer
var timer_counter=0
var protagonist = null


func _on_Area2D_body_entered(body):
	if body.name == "protagonist":
		protagonist = body
		body.pick_up_triforce()
		position = Vector2(body.position.x,body.position.y-36)
		timer.start()
	pass # Replace with function body.


func _on_Timer_timeout():
	timer_counter+=1
	print(timer_counter)
	if timer_counter==2:
		queue_free()
		protagonist.toggle_action()
		protagonist.mobile=true
		
