extends Node2D

onready var nav_2d = $Navigation2D
onready var prot = $protagonist
onready var map = $Navigation2D/TileMap
var ant = load("res://antagonist.tscn")
var zombie = load("res://ZombieType.tscn")
var list_of_units=[ant,zombie]
var ms = 2


func return_path(unit, target):
	var simple_path = nav_2d.get_simple_path(target,unit,false)
	return simple_path
	
func spawn_unit():
	randomize()
	var unit=list_of_units[randi()%2].instance()
	var unit_position=Vector2(prot.global_position.x + rand_range(-200,200),prot.global_position.y + rand_range(-200,200))
	print(map.get_cell(unit_position.x,unit_position.y))
	var space = get_world_2d().get_direct_space_state()
	var result = space.intersect_point(unit_position,32,[],214783647,false,true)
	if (not result.empty()): 
		print("Hit at point:",result)
		get_tree().get_root().add_child(unit)
		unit.set_position(unit_position)
	else: print("nothing on "+str(position))
	

func _on_Timer_timeout():
	#print(get_viewport().get_visible_rect().size/2)
	ms -=1
	if ms == 0:
		#spawn_unit()
		ms=4
