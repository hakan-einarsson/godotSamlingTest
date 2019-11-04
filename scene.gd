extends Node2D


onready var nav_2d = $Navigation2D


	
func return_path(unit, target):
	var simple_path = nav_2d.get_simple_path(target,unit,false)
	set_process(true)
	return simple_path
