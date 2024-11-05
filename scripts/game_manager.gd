extends Node

func _ready():
	var health_bar = $"../Control/health_bar"
	var health = 10
	health_bar.set_value(health)
