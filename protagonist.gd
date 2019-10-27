extends KinematicBody2D
onready var timer = get_node("Timer")

var on_cooldown = false
var ms = 3
var health = 100

var speed = 100
var direction = Vector2()
var movement = Vector2()
var projektilScen = load("res://projektil.tscn")
var explosion_scen = load("res://Explosion.tscn")
# Called when the node enters the scene tree for the first time.

func _input(event):
	movement.x = (int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left")))*speed
	movement.y = (int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up")))*speed

	if event.is_action_pressed("ui_accept"): 
		shoot()
			
		# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(movement)
	if health <=0:
		death()
	
func take_damage(damage,recipient):
	health-=damage
	print(health)

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
		projektil.shoot(global_position,get_global_mouse_position(),self)
		get_parent().add_child(projektil)
		
func death():
	var explosion = explosion_scen.instance()
	explosion.explodera(global_position)
	get_parent().add_child(explosion)
	get_parent().remove_child(self)
	
func get_health():
	return health
