extends Node2D

onready var nav_2d = $Navigation2D
onready var prot = $protagonist
onready var map = $Navigation2D/TileMap
var stair_scen = load("res://assets/Stairway.tscn")
var ant = load("res://characters/antagonist.tscn")
var zombie = load("res://characters/ZombieType.tscn")
var triforce_scen = load("res://assets/Triforce.tscn")
var list_of_units=[ant,zombie]
var spawn_counter = 9
var phase = [10,9,8,7,6,5,4,3]
var phase_counter = 0
var scen_running = true

func _ready():
	global.stage="SurvivalScen"

func return_path(unit, target):
	var simple_path = nav_2d.get_simple_path(target,unit,false)
	return simple_path
	
func spawn_unit():
	randomize()
	var unit=list_of_units[randi()%2].instance()
	var unit_position=Vector2(rand_range(40,980),rand_range(40,570))
	call_deferred("add_child",unit)
	unit.set_position(unit_position)

func _on_SpawnTimer_timeout():
	spawn_counter+=1
	if spawn_counter >= phase[phase_counter] and scen_running:
		spawn_unit()
		spawn_counter=0


func _on_ScenTimer_timeout():
	phase_counter += 1
	if phase_counter == len(phase)-1:
		scen_running=false
		var triforce = triforce_scen.instance()
		call_deferred("add_child",triforce)
		triforce.position = Vector2(512,161)
		

func triforce_picked_up():
	var stairway = stair_scen.instance()
	call_deferred("add_child",stairway)
	stairway.position=Vector2(944,80)
	
func next_scen():
	get_tree().change_scene("res://scenes/PreScen3.tscn")
	
