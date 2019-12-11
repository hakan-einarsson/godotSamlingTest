extends ProgressBar

onready var bar = get_node("TextureProgress")
var cast_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible=false
	bar.visible=false
	bar.value=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
		

func set_cast_time(time):
	cast_time = time
	bar.max_value=cast_time
	self.visible=true
	bar.visible=true	
	
func reset_cast_bar():
	self.visible=false
	bar.visible=false
	bar.value=0
	cast_time = 0
	
func update_cast_bar():
	bar.value+=1

