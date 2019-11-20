extends KinematicBody2D


# Declare member variables here. Examples:
onready var animation_player = $Sprite/AnimationPlayer
onready var cast_timer = $CastTimer
onready var sprite = $Sprite
onready var cast_bar = $CastBar
onready var collision_shape = $CollisionShape2D


var dragon_fire_scen = load("res://spells/DragonFire.tscn")
var floating_text_scen = load("res://Interface/Text.tscn")
var PopupDamageObject = load("res://Interface/PopupDamage.tscn")
var direction = Vector2()
var phase = 0
var max_health=500
var health = max_health
var animationState = "Down"
var collision_shape_rotated = false
var alive = true

signal health_changed(new_value)


var is_casting=false
var target = null
var spell = null
var cast_time = 0
var cast_time_counter = 0
var casting_spell=null
var path=[]
var speed = 100


func _ready():
	animation_player.play(animationState)
	#for unit in get_parent().return_units():
		#if unit.name=="protagonist":
			#target = unit



func _physics_process(delta):
	if target and target.health > 0 and alive:
		casting_spell=dragon_fire_scen
		set_animation(target.position)
		if is_casting and (cast_time-cast_time_counter) < 5:
			animation_player.play("Shoot"+animationState)
		if position.distance_to(target.position) > 300 or not in_sight(target):
			if is_casting:
				cancel_cast()
				is_casting=false
			path = get_parent().return_path(target.position,position)
			move_along_path(speed)
				
		else:
			if is_casting:
				if cast_time_counter==cast_time:
					cast_complete()
					is_casting=false
			else:
				cast_start(casting_spell)
				is_casting=true
	if health <=0:
		death()
		
func death():
	alive=false
	animation_player.play("Die")
			
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
			print(result.collider.name)
			#if result.collider.name == "protagonist" or result.collider.name=="ZombieType" or result.collider.name=="antagonist":
			return true
		else:
			return false




func _on_Area2D_body_entered(body):
	if body.name=="protagonist":
		target=body
		get_parent().spawn_timer.start()
