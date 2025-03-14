extends Node3D

@export var enemy_scene : PackedScene
@onready var gold = $"../../gamegui/PanelContainer/MarginContainer/GridContainer/gold"
@onready var explosion = $explosion
@onready var moneysound = $moneysound

func _ready():
	# Spawn first enemies
	if Global.level == 1:
		spawn_enemy(10, 0, 0)
		spawn_enemy(-20, 0, 10)
		spawn_enemy(-20, 0, 15)
	if Global.level == 2:
		spawn_enemy(-11.49, 0, -12.154)
		spawn_enemy(0.863, 0, -8.328)
		spawn_enemy(3.474, 0, 10.794)
		spawn_enemy(-4.919, 0 , -1.076)
		spawn_enemy(-11.918, 0, -1.425)
	if Global.level == 3:
		spawn_enemy(4.587, 0, 7.336)
		spawn_enemy(9.409, 0, -15.724)
		spawn_enemy(-2.894, 0, -26.926)
		spawn_enemy(2.833, 0, -26.687)
		spawn_enemy(-5.356, 0, 3.008)
		spawn_enemy(5.894, 0, -4.434)
		spawn_enemy(-15.296, 0, -9.464)
		spawn_enemy(7.917, 0, 1.951)
		spawn_enemy(-0.09, 0, -24.523)
	if Global.level == 4:
		spawn_enemy(-9.24, 0, 9.121)
		spawn_enemy(2.687, 0, 2.164)
		spawn_enemy(-1.407, 0, 2.395)
		spawn_enemy(-3.001, 0, 10.038)
		spawn_enemy(7.83, 0, 15.435)
		spawn_enemy(-9.368, 0, 15.898)
		spawn_enemy(-0.717, 0, 13.566)
		spawn_enemy(1.291, 0, 9.385)
		spawn_enemy(6.933, 0, 8.753)
		spawn_enemy(-9.474, 0, 2.025)
		spawn_enemy(8.288, 0, 2.862)

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
