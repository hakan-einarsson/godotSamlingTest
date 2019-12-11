extends Node2D

var damage = 100
var direction = Vector2()
var speed = 200



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction*speed*delta
	scale +=Vector2(1,1)*(speed*delta)*delta
	
func set_position_and_direction(pos,dir):
	global_position = pos
	direction = dir


func _on_Area2D_body_entered(body):
	if body.name == "TileMap":
		queue_free()
	elif body.name == "protagonist":
		body.take_damage(damage,self)
		queue_free()