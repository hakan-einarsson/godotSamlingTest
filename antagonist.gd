extends KinematicBody2D
onready var timer = get_node("Timer")
onready var animation_player = get_node("Sprite/AnimationPlayer")
var labelScen = load("res://TextLabel.tscn")

var target = null
var on_cooldown = false
var ms = 8
var speed = 50
var animationState = "Down"

var projektilScen = load("res://AntagonistProjektil.tscn")
var floating_text_scen = load("res://Interface/Text.tscn")
signal health_changed(new_value)

var explosion_scen = load("res://Explosion.tscn")
export var max_health = 100
var health = 100
var direction = Vector2(0,1)
var movement

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
		shoot()
		direction = Vector2(cos(get_angle_to(target.position)),sin(get_angle_to(target.position)))
		movement = direction * speed
		move_and_slide(movement)
	else:
		if randi()%100==1:
			direction = random_movement()
		movement = direction*speed*delta
		var collision = move_and_collide(movement)
		if collision:
			direction = random_movement()
	if health <= 0:
		death()
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
	

func _on_AggroRange_body_entered(body):
	if body.get_name() == "protagonist":
		target = body

func shoot():
	if not on_cooldown and target.health > 0:
		timer.start()
		on_cooldown = true;
		var projektil = projektilScen.instance()
		get_parent().add_child(projektil)
		projektil.shoot(global_position,target.global_position,self)
		
func _on_Timer_timeout():
	if on_cooldown:
		ms-=1
		if ms == 0:
			ms=3
			on_cooldown=false
			
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
	
	
				


