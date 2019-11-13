extends ProgressBar

onready var bar = get_node("TextureProgress")
onready var timer = get_node("Timer")
var ms = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible=false
	bar.visible=false
	bar.max_value=get_parent().max_health
	bar.value=get_parent().max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_antagonist_health_changed(new_value):
	ms=15
	bar.value=new_value
	timer.start()


func _on_Timer_timeout():
	if ms > 0:
		self.visible=true
		bar.visible=true
		ms-=1
	else:
		self.visible=false
		bar.visible=false
		timer.stop()
	


func _on_ZombieType_health_changed(new_value):
	pass # Replace with function body.
