extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal picked_up(name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name=="protagonist":
		body.keys_update(1)
		emit_signal("picked_up",self.name)
		queue_free()
