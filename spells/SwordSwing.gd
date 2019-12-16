extends Sprite

var damage = 1000
onready var animator = $AnimationPlayer
# Called when the node enters the scene tree for the first time.

func swing(target,source):
	show()
	animator.play("Swing")
	target.take_damage(damage,source)
	
func player_swing(targets,source):
	show()
	animator.play("Swing")
	if targets != []:
		for target in targets:
			target.take_damage(damage,source)

func swing_stop():
	animator.stop()
	hide()


func show():
	visible=true

func hide():
	visible=false
