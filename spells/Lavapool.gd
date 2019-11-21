extends Node2D

onready var animation_player = $Sprite/AnimationPlayer
onready var timer = $Timer
var target = null
var time = 10
var damage = 25
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("bubbling")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name=="protagonist":
		target = body


func _on_Area2D_body_exited(body):
	if body.name=="protagonist":
		target = null


func _on_Timer_timeout():
	time -=1
	if time <= 0:
		queue_free()
	if target:
		target.take_damage(damage,target)

