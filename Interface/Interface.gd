extends Control

onready var healthbar = get_node("Healthbar/TextureProgress")
onready var hit_cooldown_text = $HitCooldown/Label
onready var hit_coodlwon = $HitCooldown
onready var drink_cooldown_text = $PotCooldown/Label
onready var drink_coodlwon = $PotCooldown
onready var dash_cooldown_text = $DashCooldown/Label
onready var dash_coodlwon = $DashCooldown
onready var key_count = $Control/key_field/key_count
onready var key_field = $Control/key_field

# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar.max_value = get_parent().get_parent().max_health
	healthbar.value = get_parent().get_parent().health
	

func _on_protagonist_health_changed(new_value):
	healthbar.value = new_value


func _on_protagonist_cooldown_update(cooldown, new_value, hide):
	if cooldown == "Hit":
		hit_cooldown_text.text=str(new_value+1)
		if not hide:
			hit_coodlwon.visible=true
		else:
			hit_coodlwon.visible=false
			
	if cooldown == "Drink":
		drink_cooldown_text.text=str(new_value+1)
		if not hide:
			drink_coodlwon.visible=true
		else:
			drink_coodlwon.visible=false
	if cooldown == "Dash":
		dash_cooldown_text.text=str(new_value+1)
		if not hide:
			dash_coodlwon.visible=true
		else:
			dash_coodlwon.visible=false

func _on_protagonist_key_count_changed(new_value):
	key_field.visible=true
	key_count.text=str(new_value)



func _on_AttackButton_gui_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().get_parent().hit()
	pass # Replace with function body.


func _on_RangedAttack_gui_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().get_parent().cast()
	pass # Replace with function body.


func _on_Potion_gui_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().get_parent().drink()
	pass # Replace with function body.


func _on_Dash_gui_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().get_parent().dash()
	pass # Replace with function body.
