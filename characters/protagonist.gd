extends KinematicBody2D
onready var hit_cooldown_timer = $HitCooldownTimer
onready var drink_cooldown_timer = $DrinkTimer
onready var dash_cooldown_timer = $DashTimer
onready var cast_timer = $CastTimer
onready var animation_player = get_node("Sprite/AnimationPlayer")
onready var cast_bar = $ProgressBar
onready var walk_anim=$Sprite
onready var action_anim=$ActionSprite
onready var sword_swing=$SwordSwing
onready var blue_circle = $BlueCircle
onready var death_timer=$DeathTimer
onready var sound_player = $Sound

var target = null
var target_marker=null
var enemy = false

#var hit_cooldown_time = 5
var hit_counter = 0
var max_health=200
var health = max_health
var alive = true
var speed = 120
var movement = Vector2()
var invulnerable = false
var projektilScen = load("res://spells/projektil.tscn")
var explosion_scen = load("res://assets/Explosion.tscn")
var dash_target_scen = load("res://Interface/Target.tscn")
var target_marker_scen = load("res://Interface/TargetMarker.tscn")
var potion_sound = load("res://assets/sounds/potion.wav")
var death_sound = load("res://assets/sounds/death.wav")

var cooldowns = {"Hit":5,
			"Drink":300,
			"Dash":150}
var cooldown_counters = {"Hit":5,
			"Drink":300,
			"Dash":150}

var spell=null
var is_casting=false
var cast_time = 0
var cast_time_counter=0

var is_dashing = false
var is_targeting=false
var dash_target=null
var dash_position = Vector2()
var dash_speed = 500
var mobile = true
#var dash_on_cooldown=false


var targets_in_melee_range=[]
var rot = 0

var PopupDamageObject = load("res://Interface/PopupDamage.tscn")
var floating_text_scen = load("res://Interface/Text.tscn")

var keys = 0
var animationState = "Down"
signal health_changed(new_value)
signal cooldown_update(cooldown, new_value, hide)
signal key_count_changed(new_value)

func _ready():
	sword_swing.visible=false

func _input(event):
	movement.x = (int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left")))*speed
	movement.y = (int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up")))*speed
	
	
	if event.is_action_pressed("ui_hit"): 
		hit()
	
	
	if event.is_action_pressed("ui_cast"): 
		cast()
		
	
	if event.is_action_pressed("ui_drink"):
		drink()

	
	if event.is_action_pressed("ui_dash"): 
		dash()
			
	if event.is_action_pressed("ui_accept") and is_targeting:
		target_dash()

			
	if event.is_action_pressed("ui_accept") and not is_targeting:
		targeting()
		
	if event.is_action_pressed("ui_focus_next"):
		print("tab pressed")
			

		
		
func targeting():
	var space = get_world_2d().direct_space_state
	var collision = space.intersect_point(get_global_mouse_position())
	if collision and collision[0].collider.name != "TileMap":
		if collision[0].collider.name != "protagonist":
			if target:
				target_marker.queue_free()
			target = collision[0].collider
			target_marker = target_marker_scen.instance()
			if target.name=="Dragon":
				target_marker.set_scale(Vector2(2,2))
			get_parent().call_deferred("add_child",target_marker)
			
func hit():
	if cooldown_counters["Hit"]==cooldowns["Hit"] and not is_casting:
		cooldown_counters["Hit"]=0
		sword_swing.rotate(-rot)
		rot = position.angle_to_point(get_global_mouse_position())+deg2rad(90)
		sword_swing.rotate(rot)
		sword_swing.player_swing(targets_in_melee_range,self)
		hit_cooldown_timer.start()
		
func cast():
	if target:
		cast_start(projektilScen)
		
func drink():
	if cooldown_counters["Drink"]==cooldowns["Drink"] and not is_casting: 
		if health+100 <= max_health:
			take_damage(-100,self)
			emit_signal("health_changed",health)
		else:
			take_damage(-(max_health-health),self)
			emit_signal("health_changed",health)
		cooldown_counters["Drink"]=0
		sound_player.stream=potion_sound
		sound_player.volume_db=-20
		sound_player.play()
		drink_cooldown_timer.start()
		
func dash():
	if cooldown_counters["Dash"]==cooldowns["Dash"]:
		if not is_targeting:
			dash_target = dash_target_scen.instance()
			get_parent().add_child(dash_target)
			is_targeting=true
		else:
			is_targeting=false
			dash_target.remove_target()
			
func target_dash():
	cooldown_counters["Dash"]=0
	dash_position=dash_target.position
	dash_target.set_target_position(get_global_mouse_position())
	if is_casting:
		cancel_cast()
	is_dashing=true
	is_targeting=false
	dash_cooldown_timer.start()
			
			

func _physics_process(delta):
	if Input.is_action_pressed("on_click_move"):
		movement.x=cos(get_angle_to(get_global_mouse_position()))*speed
		movement.y=sin(get_angle_to(get_global_mouse_position()))*speed
	if target:
		target_marker.position = target.position
		if target.health <= 0:
			target=null
			target_marker.queue_free()
	if not is_casting:
		set_animation(get_global_mouse_position())
	if is_dashing:
		if position != dash_position:
			var angle_to = Vector2(cos(get_angle_to(dash_position)),sin(get_angle_to(dash_position)))
			var collision = move_and_collide(angle_to*dash_speed*delta)
			if collision:
				dash_target.remove_target()
				is_dashing = false
			
		else:
			is_dashing = false
	else:
		if movement == Vector2():
			animation_player.stop()
		if mobile:
			movement = move_and_slide(movement)
			if movement and is_casting:
				cancel_cast()
	if health <=0:
		death()
		
		
	
func in_sight(body):
	var space_state = get_world_2d().direct_space_state
	#print(position, body.position)
	if body.position != position:
		var result = space_state.intersect_ray(position, body.position,[self])
		if result:
			if result.collider.name != "TileMap":
				return true
			else:
				return false

func take_damage(amount,source):
	if not invulnerable:
		var floating_text = floating_text_scen.instance()
		floating_text.position=position
		floating_text.velocity = Vector2(0,-100)
		if amount > 0:
			floating_text.set_color(Color(1,0,0))
			floating_text.text = "-"+str(amount)
		else:
			floating_text.set_color(Color(0,1,0))
			floating_text.text = "+"+str(amount)
		get_parent().call_deferred("add_child",floating_text)
		health-=amount
	else:
		pass

	emit_signal("health_changed", health)

func cast_start(spell_type):
	if not is_casting:
		spell = spell_type.instance()
		cast_time = spell.get_cast_time()
		cast_bar.set_cast_time(cast_time)
		cast_timer.start()
		action_sprite()
		animation_player.play("Cast")
		is_casting = true
		blue_circle.emitting=true
		
func cancel_cast():
	cast_timer.stop()
	if sound_player.is_playing():
		sound_player.stop()
	is_casting = false
	cast_time=0
	cast_time_counter=0
	spell.cancel()
	cast_bar.reset_cast_bar()
	walking_sprite()
	blue_circle.emitting=false
	

func cast_complete():
	get_parent().call_deferred("add_child",spell)
	#get_parent().add_child(spell)
	if target:
		spell.shoot(global_position,target,self)
		spell.rotate(get_angle_to(target.position))
	else:
		spell.shoot(global_position,get_global_mouse_position(),self)
		spell.rotate(get_angle_to(get_global_mouse_position()))
	cast_time = 0
	cast_time_counter = 0
	is_casting=false
	cast_bar.reset_cast_bar()
	walking_sprite()
	blue_circle.emitting=false
		
func death():
	if alive:
		var explosion = explosion_scen.instance()
		explosion.explodera(global_position)
		get_parent().add_child(explosion)
		walk_anim.visible=false
		mobile=false
		alive=false
		get_parent().get_node("Music").stop()
		sound_player.stream=death_sound
		sound_player.volume_db=-20
		sound_player.play()
		death_timer.start()
		print("death_timer start")

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
			
func angle_to_vector2(string):
	if string == "Right":
		return Vector2(1,0)
	if string == "Left":
		return Vector2(-1,0)
	if string == "Up":
		return Vector2(0,-1)
	if string == "Down":
		return Vector2(0,1)

func show_damage_text(damage):
	var popupDamageText = PopupDamageObject.instance()
	get_tree().get_root().add_child(popupDamageText)
	popupDamageText.set_global_position(global_position)
	popupDamageText.set_position_offset(-8,-20)
	popupDamageText.set_damage_text(damage)
	

func _on_CastTimer_timeout():
	if cast_time_counter==3:
		sound_player.stream=load("res://assets/sounds/casting.wav")
		sound_player.volume_db=-30
		sound_player.play()
	if sound_player.is_playing() and sound_player.volume_db < -15:
		sound_player.volume_db+=5
	cast_time_counter+=1
	cast_bar.update_cast_bar()
	if cast_time_counter == cast_time:
		cast_complete()
		cast_timer.stop()
	
func action_sprite():
	walk_anim.visible=false
	action_anim.visible=true

func walking_sprite():
	walk_anim.visible=true
	action_anim.visible=false

func _on_MeleeRange_body_entered(body):
	if body.name != "TileMap" and body.name != self.name:
		if body.enemy:
			targets_in_melee_range.append(body) # Replace with function body.
	


func _on_MeleeRange_body_exited(body):
	if body.name != "TileMap" and body.name != self.name:
		if body.enemy:
			targets_in_melee_range.erase(body)
	
func dash_complete():
	is_dashing=false

func _on_HitCooldownTimer_timeout():
	if cooldown_counters["Hit"] < cooldowns["Hit"]:
		cooldown_counters["Hit"]+=1
		var time_left = ceil((cooldowns["Hit"]-cooldown_counters["Hit"])/10)
		emit_signal("cooldown_update","Hit",time_left,false)
		if cooldown_counters["Hit"] == cooldowns["Hit"]:
			emit_signal("cooldown_update","Hit",time_left,true)
			hit_cooldown_timer.stop()


func _on_DrinkTimer_timeout():
	if cooldown_counters["Drink"] < cooldowns["Drink"]:
		cooldown_counters["Drink"]+=1
		var time_left = ceil((cooldowns["Drink"]-cooldown_counters["Drink"])/10)
		emit_signal("cooldown_update","Drink",time_left,false)
		if cooldown_counters["Drink"] == cooldowns["Drink"]:
			emit_signal("cooldown_update","Drink",time_left,true)
			drink_cooldown_timer.stop()


func _on_DashTimer_timeout():
	if cooldown_counters["Dash"] < cooldowns["Dash"]:
		cooldown_counters["Dash"]+=1
		var time_left = (cooldowns["Dash"]-cooldown_counters["Dash"])/10
		emit_signal("cooldown_update","Dash",time_left,false)
		if cooldown_counters["Dash"] == cooldowns["Dash"]:
			emit_signal("cooldown_update","Dash",time_left,true)
			dash_cooldown_timer.stop()

func pick_up_triforce():
	toggle_action()
	mobile=false
	invulnerable=true
	get_parent().triforce_picked_up()
	
func toggle_action():
	if walk_anim.visible and not action_anim.visible:
		walk_anim.visible=false
		action_anim.visible=true
	else:
		walk_anim.visible=true
		action_anim.visible=false

func keys_update(value):
	keys+=value
	emit_signal("key_count_changed",keys)
		


func _on_DeathTimer_timeout():
	print("DeathTimer tick")
	get_tree().change_scene("res://scenes/DeathScreen.tscn")
	
