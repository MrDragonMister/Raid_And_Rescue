extends Node

@onready var health := 10
@onready var health_bar := $"../Control/health_bar"
#@onready health_bar.set_value(health)

func _ready():
	health_bar.value = health	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		for n in 10:
			health -= 1
			health_bar.value = health
			await get_tree().create_timer(0.01).timeout
	if Input.is_action_just_pressed("interact"):
		for n in 10:
			health += 1
			health_bar.value = health
			await get_tree().create_timer(0.01).timeout
		
