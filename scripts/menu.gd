extends Node2D

@onready var death = $death

func _ready():
	# death.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Global.gold = 0

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

func _on_button_3_pressed() -> void:
	get_node("Weapon_shop").visible = true
	get_node("Weapon_shop/Anim").play("TransIn")
	
