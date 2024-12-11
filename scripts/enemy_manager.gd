extends Node3D

@export var enemy_scene : PackedScene

func _unhandled_input(_event):
	if Input.is_action_just_pressed("spawn enemy"):
		spawn_enemy(Vector3(randi_range(-10, 10), 0, randi_range(-10, 10)))
	
func spawn_enemy(pos):
	var mob = enemy_scene.instantiate()
	Global.enemy_spawn_pos = pos
	add_child(mob)
	# This needs to be global because you get a null instance when 2 enemies die at the same time
	Global.amount_of_enemies += 1
	
#func enemy_die():
#	Global.amount_of_enemies -= 1
#	Global.gold += 3
