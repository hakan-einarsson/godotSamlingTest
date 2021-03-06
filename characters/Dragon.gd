extends KinematicBody2D


# Declare member variables here. Examples:
onready var animation_player = $Sprite/AnimationPlayer
onready var cast_timer = $CastTimer
onready var sprite = $Sprite
onready var cast_bar = $CastBar
onready var collision_shape = $CollisionShape2D
onready var bolt_timer = $BoltTimer


var dragon_fire_scen = load("res://spells/DragonFire.tscn")
var floating_text_scen = load("res://Interface/Text.tscn")
var PopupDamageObject = load("res://Interface/PopupDamage.tscn")
var triforce_scen=load("res://assets/Triforce.tscn")
var direction = Vector2()
var max_health=1000
var health = max_health
var animationState = "Down"
var collision_shape_rotated = false
var alive = true
var phase = 1
var phase2 = false
var enemy = true
var death_pos = Vector2()

signal health_changed(new_value)


var is_casting=false
var target = null
var spell = null
var cast_time = 0
var cast_time_counter = 0
var casting_spell=null
var path=[]
var speed = 100
#var point_straight_down=Vector2()
var radius = 450/PI
#var rad_shock = Vector2(0,1)*radius
var shock_wave_bolt = load("res://spells/ShockWaveBolt.tscn")
var bolt_angle=1


func _ready():

	animation_player.play(animationState)
	#for unit in get_parent().return_units():
		#if unit.name=="protagonist":
			#target = unit

func set_direction_of_bolt(pos,ang,rad):
	var dir = Vector2(cos(ang),sin(ang))
	var spos = pos + dir*rad
	return [dir, spos]

func shock_wave():
	#var point_straight_down=position+rad_shock
	var bolt = shock_wave_bolt.instance()
	var props = set_direction_of_bolt(position,bolt_angle*2,radius)
	get_parent().add_child(bolt)
	bolt.set_position_and_direction(props[1],props[0])
	bolt_angle=rand_range(0,360)


func _physics_process(delta):
	if health <=0:
		death()
	if alive:
		phase = floor(1/(float(health)/max_health))

	if target and target.health > 0 and alive:
		if phase == 1 or phase >= 5:
			if phase2:
				phase2=false
				bolt_timer.stop()
				is_casting=false
				cast_time_counter=0
			casting_spell=dragon_fire_scen
			set_animation(target.position)
			if is_casting and (cast_time-cast_time_counter) < 5:
				animation_player.play("Shoot"+animationState)
			if position.distance_to(target.position) > 400 or not in_sight(target): #den här gör att han ibland kastar när han rör sig...
				if is_casting:
					cancel_cast()
				path = get_parent().return_path(target.position,position)
				move_along_path(speed)
			else:
				if is_casting:
					if cast_time_counter==cast_time:
						cast_complete()
				else:
					if position.distance_to(target.position) <= 300:
						cast_start(casting_spell)
					else:
						if is_casting:
							cancel_cast()
						path = get_parent().return_path(target.position,position)
						move_along_path(speed)
		if phase >= 2 and phase < 5:
			if not position.y < 290:
				path = get_parent().return_path(Vector2(460,270),position)
				set_animation(Vector2(460,270))
				move_along_path(speed)
			else:
				if not phase2:
					animation_player.play("Down")
					bolt_timer.start()
					get_parent().lavapool_timer.start()
					phase2 = true
		
			
						
	

		
		
func death():
	alive=false
	death_pos=position
	animation_player.play("Die")
	queue_free()
	add_triforce()
			
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
		
func cast_start(spell_type):
	if not is_casting and target.health > 0:
		spell = spell_type.instance()
		cast_time = spell.get_cast_time()
		cast_bar.set_cast_time(cast_time)
		cast_timer.start()
		is_casting = true
		
func cancel_cast():
	cast_timer.stop()
	is_casting = false
	cast_time=0
	cast_time_counter=0
	spell.cancel()
	cast_bar.reset_cast_bar()
	

func cast_complete():
	var projektil = casting_spell.instance()
	get_parent().add_child(projektil)
	projektil.shoot(global_position,target,self)
	cast_time = 0
	cast_time_counter = 0
	is_casting=false
	cast_bar.reset_cast_bar()
		
func _on_CastTimer_timeout():
	cast_time_counter+=1
	cast_bar.update_cast_bar()
		
func show_damage_text(damage):
		var popupDamageText = PopupDamageObject.instance()
		get_tree().get_root().add_child(popupDamageText)
		popupDamageText.set_global_position(global_position)
		popupDamageText.set_position_offset(-8,-20)
		popupDamageText.set_damage_text(damage)
		
func set_animation(target_pos):
	if get_player_state(target_pos) != animationState:
		animationState=get_player_state(target_pos)
	animation_player.play(animationState)

func get_player_state(target_position):
	var angleToMouse = get_angle_to(target_position)
	if abs(angleToMouse) <= 1:
		sprite.set_flip_h(false)
		if not collision_shape_rotated:
			collision_shape.rotate(deg2rad(90))
			collision_shape_rotated=true
		return("Right")
	elif abs(angleToMouse) >= 2:
		sprite.set_flip_h(true)
		if not collision_shape_rotated:
			collision_shape.rotate(deg2rad(90))
			collision_shape_rotated=true
		return("Right")
	else:
		if angleToMouse > 0:
			sprite.set_flip_h(false)
			if collision_shape_rotated:
				collision_shape.rotate(deg2rad(90))
				collision_shape_rotated=false
			return("Down")
		else:
			sprite.set_flip_h(false)
			if collision_shape_rotated:
				collision_shape.rotate(deg2rad(90))
				collision_shape_rotated=false
			return("Up")
			
func in_sight(body):
	var space_state = get_world_2d().direct_space_state
	#print(position, body.position)
	if body.position != position:
		var result = space_state.intersect_ray(position, body.position,[self],5)
		if result and result.collider.name != "TileMap":
			return true
		else:
			return false




func _on_Area2D_body_entered(body):
	if body.name=="protagonist":
		
		target=body
		get_parent().spawn_timer.start()


func _on_BoltTimer_timeout():
	shock_wave()
	
func add_triforce():
	var triforce = triforce_scen.instance()
	get_parent().call_deferred("add_child",triforce)
	triforce.position=death_pos

	
