extends Node2D

onready var nav_2d = $Navigation2D
onready var prot = $protagonist
onready var map = $Navigation2D/TileMap
var ant = load("res://antagonist.tscn")
var zombie = load("res://ZombieType.tscn")
var list_of_units=[ant,zombie]
var spawn_counter = 9
var phase = [10,9,8,7,6,5,4,3]
var phase_counter = 0
var scen_running = true


func return_path(unit, target):
	var simple_path = nav_2d.get_simple_path(target,unit,false)
	return simple_path
	
func spawn_unit():
	randomize()
	var unit=list_of_units[randi()%2].instance()
	var unit_position=Vector2(rand_range(40,980),rand_range(40,570))
	print("added unit at",unit_position)
	add_child(unit)
	unit.set_position(unit_position)
	


func _on_SpawnTimer_timeout():
	spawn_counter+=1
	print(spawn_counter)
	if spawn_counter == phase[phase_counter] and scen_running:
		#print("phase: ",phase_counter," ",phase[phase_counter])
		spawn_unit()
		spawn_counter=0


func _on_ScenTimer_timeout():
	phase_counter += 1
	print(phase_counter)
	if phase_counter == len(phase)-1:
		scen_running=false
		print("scen_running",scen_running)
