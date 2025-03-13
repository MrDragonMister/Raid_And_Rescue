extends Node3D

@export var enemy_scene : PackedScene
@onready var gold = $"../../gamegui/PanelContainer/MarginContainer/GridContainer/gold"
@onready var explosion = $explosion
@onready var moneysound = $moneysound

func _ready():
	# Spawn first enemies
	spawn_enemy(10, 0, 0)
	spawn_enemy(-20, 0, 10)
	spawn_enemy(-20, 0, 15)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("spawn enemy"):
		spawn_enemy(randi_range(-10, 10), 0, randi_range(-10, 10))
	
func spawn_enemy(x, y, z):
	var mob = enemy_scene.instantiate()
	Global.enemy_spawn_pos = Vector3(x, y, z)
	add_child(mob)
	# This needs to be global because you get a null instance when 2 enemies die at the same time
	Global.amount_of_enemies += 1

func enemy_die():
	explosion.play()
	Global.amount_of_enemies -= 1
	await get_tree().create_timer(1).timeout #explosion.finished
	gold.change_coins(3)
	moneysound.play()
