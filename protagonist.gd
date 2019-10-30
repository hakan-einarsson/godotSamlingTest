extends KinematicBody2D
onready var timer = get_node("Timer")
onready var animation_player = get_node("Sprite/AnimationPlayer")

var on_cooldown = false
var ms = 3
var health = 100
var max_health=100
var speed = 100
var direction = Vector2()
var movement = Vector2()
var projektilScen = load("res://projektil.tscn")
var explosion_scen = load("res://Explosion.tscn")
var textScen = load("res://TextLabel.tscn")
var PopupDamageObject = load("res://Interface/PopupDamage.tscn")
var animationState = "Down"
signal health_changed(new_value)
# Called when the node enters the scene tree for the first time.

func _input(event):
	movement.x = (int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left")))*speed
	movement.y = (int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up")))*speed

	if event.is_action_pressed("ui_accept"): 
		shoot()
			
		# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_animation(get_global_mouse_position())
	if movement == Vector2():
		animation_player.stop()
	move_and_slide(movement)
	if health <=0:
		death()
	
func take_damage(damage,recipient):
	health-=damage
	show_damage_text(damage)
	emit_signal("health_changed", health)

func _on_Timer_timeout():
	if on_cooldown:
		ms-=1
		if ms == 0:
			ms=3
			on_cooldown=false
			
func shoot():
	if not on_cooldown:
		timer.start()
		on_cooldown = true;
		var projektil = projektilScen.instance()
		get_parent().add_child(projektil)
		projektil.shoot(global_position,get_global_mouse_position(),self)
		
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
		