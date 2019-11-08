extends KinematicBody2D
onready var timer = get_node("Timer")
onready var animation_player = get_node("Sprite/AnimationPlayer")

var on_cooldown = false
var ms = 3
var health = 100000
var max_health=100000
var speed = 100
var movement = Vector2()
var projektilScen = load("res://projektil.tscn")
var explosion_scen = load("res://Explosion.tscn")
var spell=null
var is_casting=false

var PopupDamageObject = load("res://Interface/PopupDamage.tscn")

var floating_text_scen = load("res://Interface/Text.tscn")

var animationState = "Down"
signal health_changed(new_value)
# Called when the node enters the scene tree for the first time.

func _input(event):
	movement.x = (int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left")))*speed
	movement.y = (int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up")))*speed
	
	
	if event.is_action_pressed("ui_hit"): 
		hit()
	
	if event.is_action_pressed("ui_cast"): 
		cast_start(projektilScen)
	
	if event.is_action_pressed("ui_hit"): 
		hit()
	
	if event.is_action_pressed("ui_hit"): 
		hit()
			
		# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_animation(get_global_mouse_position())
	if movement == Vector2():
		animation_player.stop()
	movement = move_and_slide(movement)
	if health <=0:
		death()
		
func hit():
	print("hit")
	

func take_damage(amount,source):
	var something = source
	var floating_text = floating_text_scen.instance()
	floating_text.position=position
	floating_text.velocity = Vector2(0,-100)
	floating_text.set_color(Color(1,0,0))
	floating_text.text = "-"+str(amount)
	get_parent().add_child(floating_text)
	health-=amount

	emit_signal("health_changed", health)

func _on_Timer_timeout():
	if on_cooldown:
		ms-=1
		if ms == 0:
			ms=3
			on_cooldown=false
			
func cast_start(spell_type):
	if not is_casting:
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
		
func death():
	var explosion = explosion_scen.instance()
	explosion.explodera(global_position)
	get_parent().add_child(explosion)
	get_parent().remove_child(self)

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
		