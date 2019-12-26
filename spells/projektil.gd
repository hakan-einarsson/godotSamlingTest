extends Area2D

# Declare member variables here. Examples:
var damage = 40
var speed = 500
var direction = Vector2()
var source = null
var cast_time = 15
var target = null

onready var sound_player = $Sound
var bolt_cast = load("res://assets/sounds/bolt_cast.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if target:
		direction = (target.position - global_position).normalized()
		position+=direction*speed*delta
	else:
		position+=direction*speed*delta
	
func get_cast_time():
	return cast_time
	
func cancel():
	queue_free()
	

func shoot(start_pos,spell_target,body):
	source = body
	self.global_position=start_pos
	if typeof(spell_target)==TYPE_VECTOR2:
		direction = (spell_target - start_pos).normalized()
		#rotate(get_angle_to(spell_target))
	else:
		target = spell_target
		#rotate(get_angle_to(spell_target.position))
	$Sound.volume_db=-15
	$Sound.play()
		
		
	

func _on_Area2d_body_entered(body):
	queue_free()
	if body.get_name() != "TileMap":
		body.take_damage(damage,source)
