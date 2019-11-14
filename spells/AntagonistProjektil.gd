extends Area2D

# Declare member variables here. Examples:
var damage = 10
var speed = 500
var direction = Vector2()
var source = null
var cast_time=15
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	direction=(target.position - self.global_position).normalized()
	position+=direction*speed*delta

func get_cast_time():
	return cast_time
	
func cancel():
	queue_free()
	
func shoot(start_pos,spell_target,body):
	target = spell_target
	source = body
	self.global_position=start_pos

	

func _on_Area2d_body_entered(body):
	queue_free()
	if body.get_name() != "TileMap":
		body.take_damage(damage,source)