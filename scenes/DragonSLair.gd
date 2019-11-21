extends Node2D

# Declare member variables here. Examples:
onready var nav_2d = $Navigation2D
onready var spawn_timer=$SpawnTimer
onready var lavapool_timer=$LavapoolTimer
onready var protagonist = $protagonist
var zombie = load("res://characters/ZombieType.tscn")
var lavapool = load("res://spells/Lavapool.tscn")

# 460,270 center, radie 200

# Called when the node enters the scene tree for the first time.
func return_path(unit, target):
	var simple_path = nav_2d.get_simple_path(target,unit,false)
	return simple_path
	
func spawn_unit():
	randomize()
	var unit=zombie.instance()
	var unit_position=Vector2(rand_range(260,660),rand_range(70,470))
	print("added unit at",unit_position)
	add_child(unit)
	unit.set_position(unit_position)
	unit.set_target(protagonist)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(get_global_mouse_position())
func spawn_lavapool():
	var pool = lavapool.instance()
	add_child(pool)
	pool.set_position(protagonist.position)


func _on_SpawnTimer_timeout():
	spawn_unit()


func _on_LavapoolTimer_timeout():
	spawn_lavapool()
