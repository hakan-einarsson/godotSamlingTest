extends Sprite

var damage = 15
onready var animator = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func swing(target,source):
	print("swing")
	toggle_visibility()
	animator.play("Swing")
	target.take_damage(damage,source)

func swing_stop():
	print("animation stoped")
	animator.stop()
	toggle_visibility()

# Called every frame. 'delta' is the elapsed time since the previous frame.




		
func toggle_visibility():
	if visible == true:
		print("animation invisible")
		visible = false
	else:
		print("animation visible")
		visible = true
