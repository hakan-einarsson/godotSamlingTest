extends Control

onready var title = $Title
onready var title_scale_anim=$Title/AnimationScale
onready var btn_new_game=$btnNewGame
onready var btn_quit=$btnQuit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

	
func startTextAnimation():
	title.visible=true
	title_scale_anim.play("Scale")
	
func showButtons():
	btn_new_game.visible=true
	btn_quit.visible=true

func _on_btnNewGame_gui_input(event):
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene("res://scenes/SurvivalScen.tscn")
	pass # Replace with function body.


func _on_btnQuit_gui_input(event):
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().quit()
	pass # Replace with function body.
