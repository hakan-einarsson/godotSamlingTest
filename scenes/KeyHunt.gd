extends Node2D


var left_has_spawned = false
var right_has_spawned = false
var caster_unit=load("res://characters/antagonist.tscn")
var skel_unit=load("res://characters/ZombieType.tscn")
var trap_gate_scen=load("res://assets/TrapGate.tscn")
var trap_gate = null
onready var nav_2d = $Navigation2D
onready var protagonist = $protagonist
onready var skel_timer=$SkelTimer
onready var trap_timer=$TrapTimer
var stairway_scen = load("res://assets/Stairway.tscn")
var left_units = [Vector2(-400,80),
				Vector2(-1120,80),
				#Vector2(-1120,500),
				Vector2(-1120,1060),
				Vector2(-250,1060),
				Vector2(-250,300),
				Vector2(-980,200),
				Vector2(-980,900),
				Vector2(-375,900),
				Vector2(-600,360),
				Vector2(-500,600),
				#Vector2(-640,200)
				]
var right_units = [Vector2(1120,80),
					Vector2(1120,520),
					Vector2(1640,80),
					Vector2(1640,520)]
					
var trap_coords = [Vector2(240,720),
					Vector2(640,720),
					Vector2(240,720),
					Vector2(640,720),
					Vector2(240,720)]
					
var trap_coords_counter=0
					
var right_side_units = []

func _ready():
	protagonist.keys_update(0)
		
func return_path(unit, target):
	var simple_path = nav_2d.get_simple_path(target,unit,false)
	return simple_path

func triforce_picked_up():
	var stairway = stairway_scen.instance()
	call_deferred("add_child",stairway)
	stairway.position= Vector2(432,-464)
	
func next_scen():
	get_tree().change_scene("res://scenes/PreScen2.tscn")

func _on_leftSpawn_body_entered(body):
	if body.name == "protagonist":
		if not left_has_spawned:
			for coord in left_units:
				var unit = caster_unit.instance()
				call_deferred("add_child",unit)
				unit.position=coord
			left_has_spawned=true
		if not skel_timer.is_paused():
			skel_timer.stop()
		

func _on_rightSpawn_body_entered(body):
	if body.name == "protagonist":
		if not right_has_spawned:
			for coord in right_units:
				var unit = caster_unit.instance()
				call_deferred("add_child",unit)
				unit.position=coord
				right_side_units.append(unit)
			right_has_spawned=true

func _on_Key3_picked_up(name):
	skel_timer.start()


func _on_Key2_picked_up(name):
	trap_gate = trap_gate_scen.instance()
	call_deferred("add_child",trap_gate)
	trap_gate.position=Vector2(480,656)
	trap_timer.start()
	


func _on_Key_picked_up(name):
	for unit in right_side_units:
		if not unit.target:
			unit.target=protagonist


func _on_SkelTimer_timeout():
	var skel = skel_unit.instance()
	call_deferred("add_child",skel)
	skel.position=Vector2(-120,80)
	skel.target=protagonist




func _on_TrapTimer_timeout():
	if trap_coords_counter < 5:
		var skel = skel_unit.instance()
		call_deferred("add_child",skel)
		skel.position=trap_coords[trap_coords_counter]
		skel.target=protagonist
		var caster = caster_unit.instance()
		call_deferred("add_child",caster)
		caster.position=trap_coords[trap_coords_counter]
		caster.target=protagonist
		trap_coords_counter+=1
	else:
		trap_timer.stop()
		remove_child(trap_gate)