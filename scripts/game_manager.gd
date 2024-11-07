extends Node

func _ready():
	var health := 10
	var health_bar := $"../Control/health_bar"
	health_bar.set_value(health)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		pass
		#health += 10
		#healt_bar.setvalue(health)
		
