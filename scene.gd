extends Node2D

onready var zombie = $ZombieType
onready var target = $protagonist
onready var nav_2d = $Navigation2D
var paths = "somethin"

func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#var simple_path = nav_2d.get_simple_path(zombie.global_position,target.global_position,false)
	#set_process(true)
	#zombie.set_path(simple_path)
	
func return_path(unit, target):
	var simple_path = nav_2d.get_simple_path(unit,target,false)
	set_process(true)
	return simple_path
