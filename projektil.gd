extends Area2D

# Declare member variables here. Examples:
var damage = 20
var speed = 500
var direction = Vector2()
var source = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	position+=direction*speed*delta
	
	
func shoot(start_pos,target,body):
	source = body
	self.global_position=start_pos
	direction = (target - start_pos).normalized()
	#print("shoot",direction)
	rotate(get_angle_to(target))
	

func _on_Area2d_body_entered(body):
	get_parent().remove_child(self)
	if body.get_name() != "TileMap":
		body.take_damage(damage,source)
