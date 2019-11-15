extends Area2D

# Declare member variables here. Examples:
var dragon_fire_scatter_scen = load("res://spells/DragonFireScatter.tscn")
var dragon_fire_target_scen = load("res://spells/DragonFireTarget.tscn")
var damage = 100
var target = null
var direction = Vector2()
var speed = 300
var source = null
var cast_time=20
var directions_scatter= [Vector2(1,1),
						Vector2(-1,1),
						Vector2(-1,-1),
						Vector2(1,-1)]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position+=direction*speed*delta
	if global_position == target:
		on_impact_scatter()

func shoot(start_pos,spell_target, body):
	target = spell_target.position
	source=body
	self.global_position=start_pos
	direction = (target - start_pos).normalized()
	create_target_area()
	print(self.name)
	
func get_cast_time():
	return cast_time
	
func create_target_area():
	var dragon_fire_target = dragon_fire_target_scen.instance()
	get_parent().add_child(dragon_fire_target)
	dragon_fire_target.set_position(target)


func cancel():
	queue_free()

func _on_DragonFire_body_entered(body):
	queue_free()
	if body.get_name() != "TileMap":
		body.take_damage(damage,source)
		
func on_impact_scatter():
	queue_free()
	for dir in directions_scatter:
		var dragon_fire_scatter = dragon_fire_scatter_scen.instance()
		get_parent().add_child(dragon_fire_scatter)
		dragon_fire_scatter.set_direction(dir)
