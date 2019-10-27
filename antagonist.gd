extends KinematicBody2D
onready var timer = get_node("Timer")

var target = null
var on_cooldown = false
var ms = 3
var speed = 100

var projektilScen = load("res://AntagonistProjektil.tscn")
# Declare member variables here. Examples:
# var a = 2
var explosion_scen = load("res://Explosion.tscn")
var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target:
		shoot()
		var direction = Vector2(cos(get_angle_to(target.position)),sin(get_angle_to(target.position)))
		var movement = direction * speed
		move_and_slide(movement)
		
	if health <= 0:
		death()
func take_damage(amount,recipient):
	health-=amount
	if target == null:
		target = recipient
	
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
