extends Sprite

var damage = 15
onready var animator = $AnimationPlayer
var targets = []
# Called when the node enters the scene tree for the first time.
func swing(source):
	animator.play("Swing")
	for target in targets:
		target.take_damage(damage,source)

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_Area2D_body_entered(body):
	if body.name != "TileMap":
		targets.append(body)
