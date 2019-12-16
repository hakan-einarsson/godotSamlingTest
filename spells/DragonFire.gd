extends Area2D

# Declare member variables here. Examples:
var dragon_fire_scatter_scen = load("res://spells/DragonFireScatter.tscn")

var damage = 100
var target = null
var direction = Vector2()
var speed = 300
var count_down = 0
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
	count_down-=speed*delta
	if count_down <= 0:
		on_impact_scatter()
	position+=direction*speed*delta

func shoot(start_pos,spell_target, body):
	target = spell_target.position
	source=body
	self.global_position=start_pos
	direction = (target - start_pos).normalized()
	count_down=start_pos.distance_to(target)
	
	#create_target_area()
	
func get_cast_time():
	return cast_time



func cancel():
	queue_free()

		
func on_impact_scatter():
	queue_free()
	for dir in directions_scatter:
		var dragon_fire_scatter = dragon_fire_scatter_scen.instance()
		get_parent().add_child(dragon_fire_scatter)
		dragon_fire_scatter.set_position(position)
		dragon_fire_scatter.set_direction(dir)

func _on_DragonFire_body_entered(body):
	queue_free()
	if body.get_name() != "TileMap":
		body.take_damage(damage,source)
