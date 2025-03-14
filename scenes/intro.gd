extends Node2D

@onready var death = $death
@onready var button: Button = $Control/Button

func _ready() -> void:
	MusicManager.play_music_for_scene(get_tree().current_scene.scene_file_path)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
