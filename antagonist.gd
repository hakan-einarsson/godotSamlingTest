extends KinematicBody2D
onready var timer = get_node("Timer")
onready var animation_player = get_node("Sprite/AnimationPlayer")
var labelScen = load("res://TextLabel.tscn")

var target = null
var on_cooldown = false
var ms = 5
var speed = 100
var animationState = "Down"

var projektilScen = load("res://AntagonistProjektil.tscn")
# Declare member variables here. Examples:
# var a = 2
var explosion_scen = load("res://Explosion.tscn")
export var max_health = 100
var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target:
		set_animation(target.position)
		shoot()
		var direction = Vector2(cos(get_angle_to(target.position)),sin(get_angle_to(target.position)))
		var movement = direction * speed
		move_and_slide(movement)
		
	if health <= 0:
		death()
func take_damage(amount,source):
	health-=amount
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
		projektil.shoot(global_position,target.global_position,self)
		get_parent().add_child(projektil)
		
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
