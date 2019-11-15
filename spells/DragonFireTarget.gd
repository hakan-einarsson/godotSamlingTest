extends Area2D

# Declare member variables here. Examples:
# var a = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_position(start_pos):
	position = start_pos

func _on_DragonFireTarget_body_entered(body):
	print(body.name," entered")
	queue_free()
