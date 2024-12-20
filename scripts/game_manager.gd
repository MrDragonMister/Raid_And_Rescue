extends Node

@onready var health := 100
@onready var health_bar := $"../gamegui/health_bar"

func _ready():
	health_bar.value = health
	
func _process(_delta: float) -> void:
	if health_bar.value <= 0 or Input.is_action_just_pressed("die"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
"""
	if Input.is_action_just_pressed("attack"):
		for n in 10:
			health = max(health - 1, health_bar.min_value)
			health_bar.value = health
			await get_tree().create_timer(0.01).timeout
	if Input.is_action_just_pressed("interact"):
		for n in 10:
			health = min(health + 1, health_bar.max_value)
			health_bar.value = health
			await get_tree().create_timer(0.01).timeout
"""
