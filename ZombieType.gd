extends KinematicBody2D

var speed = 50
var max_health = 60
var health = 60
var path = PoolVector2Array() 
onready var animator = $Sprite/AnimationPlayer
var target = null
var direction=Vector2()

var floating_text_scen = load("res://Interface/Text.tscn")
var PopupDamageObject = load("res://Interface/PopupDamage.tscn")
var explosion_scen = load("res://Explosion.tscn")
var sword_scen = load("res://SwordSwing.tscn")
signal health_changed(new_value)

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("Walk")

func _physics_process(delta):
	if direction == Vector2():
		animator.stop()
	else:
		animator.play("Walk")
	if target and target.health > 0:
		path = get_tree().get_root().get_node("scene").return_path(target.position,position)
		move_along_path(speed)
	if health <= 0:
		death()
		
func hit():
	var swordSwing = sword_scen.instance()
	swordSwing.swing(self)

func death():
	var explosion = explosion_scen.instance()
	explosion.explodera(global_position)
	get_parent().add_child(explosion)
	get_parent().remove_child(self)

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
	
func set_path(value):
	path = value
	if value.size() == 0:
		return
	set_process(true)

func _on_Area2D_body_entered(body):
	if body.name != "TileMap":
		target = body
		
func show_damage_text(damage):
		var popupDamageText = PopupDamageObject.instance()
		get_tree().get_root().add_child(popupDamageText)
		popupDamageText.set_global_position(global_position)
		popupDamageText.set_position_offset(-8,-20)
		popupDamageText.set_damage_text(damage)


func _on_MeleeRange_body_entered(body):
	if body.name != "TileMap":
		target = body
