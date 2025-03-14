extends Node2D

@onready var death = $death
@onready var button: Button = $Control/Button

func _ready():
	MusicManager.play_music_for_scene(get_tree().current_scene.scene_file_path)
	death.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_node("Weapon_shop").visible = false
	if Global.level == 1:
		button.text = "Start playing!"
	elif Global.level == 5:
		button.text = "You won, press to restart!"
	else:
		button.text = "Play next level!"

func _on_button_pressed() -> void:
	if Global.level == 1:
		get_tree().change_scene_to_file("res://scenes/level1.tscn")
	if Global.level == 2:
		get_tree().change_scene_to_file("res://scenes/level2.tscn")
	if Global.level == 3:
		get_tree().change_scene_to_file("res://scenes/level3.tscn")
	if Global.level == 4:
		get_tree().change_scene_to_file("res://scenes/levelalfred.tscn")
	if Global.level == 5:
		Global.level = 1
		Global.gold = 0
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_button2_pressed() -> void:
	pass # Replace with function body.

func _on_button_3_pressed() -> void:
	get_node("Weapon_shop").visible = true
	get_node("Weapon_shop/Anim").play("TransIn")
	
