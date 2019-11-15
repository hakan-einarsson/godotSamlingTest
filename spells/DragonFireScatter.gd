extends Area2D

# Declare member variables here. Examples:
var direction=Vector2()
var speed = 500
var damage = 25
var source = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position+=direction*speed*delta

func set_direction(vector_direction):
	direction = vector_direction
	
func set_position(start_pos):
	position = start_pos



func _on_DragonFireScatter_body_entered(body):
	queue_free()
	if body.get_name() != "TileMap":
		body.take_damage(damage,body)

