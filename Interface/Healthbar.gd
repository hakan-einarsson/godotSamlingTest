extends ProgressBar

onready var healthbar = get_node("TextureProgress")
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar.max_value = 100
	healthbar.value = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func p
