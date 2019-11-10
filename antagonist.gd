extends KinematicBody2D
onready var timer = get_node("Timer")
onready var animation_player = get_node("Sprite/AnimationPlayer")
onready var cast_bar = $CastBar


var target = null
var bodies_in_aggro_range=[]

var ms = 0
var speed = 50
var animationState = "Down"
var is_casting = false
var spell = null
var cast_time=0

var projektilScen = load("res://AntagonistProjektil.tscn")
var floating_text_scen = load("res://Interface/Text.tscn")
signal health_changed(new_value)

var explosion_scen = load("res://Explosion.tscn")
export var max_health = 100
var health = 100
var direction = Vector2(0,1)
var movement
var path = PoolVector2Array() 

var PopupDamageObject = load("res://Interface/PopupDamage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play(animationState)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target and target.health > 0:
		speed = 100
		set_animation(target.position)
		if not is_casting:
			if in_sight(target):
				cast_start(projektilScen)
				animation_player.stop()
			else:
				path = get_tree().get_root().get_node("scene").return_path(target.position,position)
				move_along_path(speed)
		else:
			if not in_sight(target):
				cancel_cast()
			else:
				if ms == cast_time:
					cast_complete()
	else:
		find_a_target(bodies_in_aggro_range)
		if randi()%100==1:
			direction = random_movement()
		movement = direction*speed*delta
		var collision = move_and_collide(movement)
		if collision:
			direction = random_movement()
	if health <= 0:
		death()
		
func move_along_path(distance):
	direction = Vector2(cos(get_angle_to(path[1])),sin(get_angle_to(path[1])))
	var movement = direction * distance
	movement = move_and_slide(movement,Vector2(0,0),false,4,1)
		
func take_damage(amount,source):
	var floating_text = floating_text_scen.instance()
	floating_text.position=position
	floating_text.velocity = Vector2(0,-100)
	floating_text.set_color(Color(1,0,0))
	floating_text.text = "-"+str(amount)
	get_parent().add_child(floating_text)
	health-=amount
	show_damage_text(amount)
	emit_signal("health_changed",health)
	#var label = labelScen.instance()
	#get_parent().add_child(label)
	#label.show_text("-"+str(amount),position)
	if target == null:
		target = source
	
func death():
	var explosion = explosion_scen.instance()
	explosion.explodera(global_position)
	get_parent().add_child(explosion)
	get_parent().remove_child(self)

func cast_start(spell_type):
	if not is_casting and target.health > 0:
		spell = spell_type.instance()
		cast_time = spell.get_cast_time()
		cast_bar.set_cast_time(cast_time)
		timer.start()
		is_casting = true
		
func cancel_cast():
	timer.stop()
	is_casting = false
	cast_time=0
	ms=0
	spell.cancel()
	cast_bar.reset_cast_bar()
	

func cast_complete():
		var projektil = projektilScen.instance()
		get_parent().add_child(projektil)
		projektil.shoot(global_position,target.global_position,self)
		cast_time = 0
		ms = 0
		is_casting=false
		cast_bar.reset_cast_bar()
		
func _on_Timer_timeout():
	ms+=1
	cast_bar.update_cast_bar()
	
			
func set_animation(target_pos):
	if get_player_state(target_pos) != animationState:
		animationState=get_player_state(target_pos)
	animation_player.play(animationState)

func get_player_state(target_position):
	var angleToMouse = get_angle_to(target_position)
	if abs(angleToMouse) <= 1:
		return("Right")
	elif abs(angleToMouse) >= 2:
		return("Left")
	else:
		if angleToMouse > 0:
			return("Down")
		else:
			return("Up")

func show_damage_text(damage):
		var popupDamageText = PopupDamageObject.instance()
		get_tree().get_root().add_child(popupDamageText)
		popupDamageText.set_global_position(global_position)
		popupDamageText.set_position_offset(-8,-20)
		popupDamageText.set_damage_text(damage)
		
func random_movement():
	var direction = {"Up": Vector2(0,-1),
	"Down": Vector2(0,1),
	"Left": Vector2(-1,0),
	"Right": Vector2(1,0)}
	var rand_key=direction.keys()[randi() % len(direction.keys())]
	animation_player.play(rand_key)
	return(direction[rand_key])
	
func get_distance(body):
	if typeof(body) == TYPE_VECTOR2:
		return position.distance_to(body)
	else:
		return position.distance_to(body.global_position)
	
func in_sight(body):
	var space_state = get_world_2d().direct_space_state
	#print(position, body.position)
	if body.position != position:
		var result = space_state.intersect_ray(position, body.position,[self])
		if result:
			if result.collider.name == "protagonist" or result.collider.name=="ZombieType" or result.collider.name=="antagonist":
				return true
			else:
				return false

func _on_AggroRange_body_entered(body):
	if body.name != "TileMap":
		bodies_in_aggro_range.append(body)
		
func _on_AggroRange_body_exited(body):
	if body in bodies_in_aggro_range:
		bodies_in_aggro_range.remove(bodies_in_aggro_range.find(body))
		
func find_a_target(possible_targets):
	if possible_targets != []:
		for tar in possible_targets:
			if in_sight(tar):
				target = tar

