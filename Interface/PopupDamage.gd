extends Node2D

# Optional
func set_position_offset(x, y):
	var new_x = get_global_position().x+x
	var new_y = get_global_position().y+y
	set_global_position(Vector2(new_x,new_y))
	pass

# Called from other scripts
func set_damage_text(damage):
	$LabelContainer/Label.set_text(str(damage))

# Called when AnimationPlayer/Popup ends
func delete():
	queue_free()