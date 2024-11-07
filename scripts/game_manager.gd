extends Node

@onready var health := 10
@onready var health_bar := $"../Control/health_bar"
#@onready health_bar.set_value(health)

func _ready():
	health_bar.value = health	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		health -= 10
		health_bar.value = health
	if Input.is_action_just_pressed("interact"):
		health += 10
		health_bar.value = health
		
