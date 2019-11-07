extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Label_gui_input(event):
	
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene("res://scene.tscn")
	pass # Replace with function body.


func _on_Label2_gui_input(event):
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().quit()
	pass # Replace with function body.

