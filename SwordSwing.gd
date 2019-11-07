extends Sprite

var damage = 15
onready var animator = $AnimationPlayer
# Called when the node enters the scene tree for the first time.

func swing(target,source):
	print("swing")
	show()
	animator.play("Swing")
	target.take_damage(damage,source)

func swing_stop():
	print("animation stoped")
	animator.stop()
	hide()


func show():
	visible=true

func hide():
	visible=false
