extends Node

@onready var health_bar: ProgressBar = $"../gamegui/health_bar"
@onready var debug_bar: ProgressBar = $"../gamegui/debug_bar"
@onready var arrow_scene: PackedScene = preload("res://scenes/arrow.tscn")
@onready var health: int = 100
var is_vilager_free: bool = false

func _ready():
	health_bar.value = health


func _process(_delta: float) -> void:
	if health_bar.value <= 0 or Input.is_action_just_pressed("die"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

"""
	if Input.is_action_just_pressed("interact") : # and player.bow_is_in_hand
		spawn_arrow()
"""

func spawn_arrow():
	var arrow = arrow_scene.instantiate()
	add_child(arrow)
	debug_bar.value += 1
	debug_bar.update_debug_bar()


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
