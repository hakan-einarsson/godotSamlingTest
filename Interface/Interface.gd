extends Control

onready var healthbar = get_node("Healthbar/TextureProgress")

# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar.max_value = get_node("../protagonist").max_health
	healthbar.value = 100

func _on_protagonist_health_changed(new_value):
	healthbar.value = new_value
