
onready var timer = get_node("Timer")


# Declare member variables here. Examples:
var ms = 5
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y-=1
	
func show_text(input, pos):
	var textLabel = get_node("RichTextLabel")
	position = pos
	textLabel.text=input
	timer.start()
	

func _on_Timer_timeout():
	print(ms)
	ms-=1
	if ms == 0:
		ms = 10
		get_parent().remove_child(self)
	
