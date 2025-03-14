extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.play_music_for_scene(get_tree().current_scene.scene_file_path)
