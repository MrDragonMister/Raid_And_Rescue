extends Node

var music_player: AudioStreamPlayer

# Opslag van muziektracks per scène
var scene_music = {
	"res://scenes/Intro.tscn": preload("res://assets/sounds/raidnrescue_alfred.wav"),
	"res://scenes/menu.tscn": preload("res://assets/sounds/raidnrescue_menu.wav"),
	"res://scenes/level1.tscn": preload("res://assets/sounds/raidnrescue_theme.wav"),
	"res://scenes/level2.tscn": preload("res://assets/sounds/raidnrescue_theme.wav"),
	"res://scenes/level3.tscn": preload("res://assets/sounds/raidnrescue_theme.wav"),
	"res://scenes/levelalfred.tscn": preload("res://assets/sounds/raidnrescue_alfred.wav"),
}

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.finished.connect(_on_music_finished)

func play_music_for_scene(scene_path):
	var new_music = scene_music.get(scene_path, null)
	if new_music and music_player.stream != new_music:
		music_player.stream = new_music
		music_player.play()

func _on_music_finished():
	music_player.play()
