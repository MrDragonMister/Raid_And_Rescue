extends Node2D

@onready var death = $death

func _ready():
	death.play()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
