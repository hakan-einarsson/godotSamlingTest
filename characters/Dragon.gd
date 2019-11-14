extends KinematicBody2D

<<<<<<< HEAD
# Declare member variables here. Examples:
var direction = Vector2()
var phase = 0


=======
var is_casting=false
var target = null
var spell
var cast_time
var cast_bar
>>>>>>> 775269ab7dcad50e227656da5518a563a5643e0f
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
<<<<<<< HEAD
func _physics_process(delta):
	pass
=======
#func _process(delta):
#	pass

func cast_start(spell_type):
	if not is_casting and target.health > 0:
		spell = spell_type.instance()
		cast_time = spell.get_cast_time()
		cast_bar.set_cast_time(cast_time)
		timer.start()
		is_casting = true
>>>>>>> 775269ab7dcad50e227656da5518a563a5643e0f
