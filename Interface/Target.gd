extends Sprite

# Declare member variables here. Examples:
# var a = 2
var target_set=false
var target_position=null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not target_set:
		position = get_global_mouse_position()
	else:
		position = target_position
	
func remove_target():
	queue_free()
	
func set_target_position(pos):
	visible=false
	target_set=true
	target_position=pos
	


func _on_Area2D_body_entered(body):
	print(body.name,"entered")
	
	if body.name == "protagonist" and target_set:
		body.dash_complete()
		queue_free()
