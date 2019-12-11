extends Node2D

var radius = 150
var shock_wave_bolt= load("res://spells/ShockWaveBolt.tscn")
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(1,1)
